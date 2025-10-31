@echo off
setlocal enabledelayedexpansion

:: ==============================
:: 1. Cấu hình biến môi trường
:: ==============================
set RESOURCE_GROUP=rg-aks-demo
set CLUSTER_NAME=aks-demo-cluster
set ACR_NAME=bacanacr0132
set NAMESPACE=free5gc
set ACR_LOGIN_SERVER=%ACR_NAME%.azurecr.io
set DOCKER_EMAIL=duongbacan2004@gmail.com

echo.
echo Kết nối đến AKS cluster...
call az aks get-credentials --resource-group %RESOURCE_GROUP% --name %CLUSTER_NAME% --overwrite-existing

echo.
echo Bật admin account cho ACR...
call az acr update -n %ACR_NAME% --admin-enabled true >nul 2>&1

echo.
echo Lấy thông tin đăng nhập từ ACR...
for /f "tokens=* usebackq" %%A in (`az acr credential show --name %ACR_NAME% --query "passwords[0].value" -o tsv 2^>nul`) do set DOCKER_PASS=%%A

if "%DOCKER_PASS%"=="" (
    echo Không lấy được mật khẩu ACR.
    exit /b
)

echo.
echo Đăng nhập Docker vào ACR...
call az acr login -n %ACR_NAME%

echo.
echo Push Docker images lên ACR (vui lòng đợi)...
call :push_with_retry %ACR_LOGIN_SERVER%/argus-server:5.0.2
call :push_with_retry %ACR_LOGIN_SERVER%/dashboard:v1

echo.
echo Tạo namespace nếu chưa có...
kubectl get namespace %NAMESPACE% >nul 2>&1 || kubectl create namespace %NAMESPACE%

echo.
echo ACR secret...
kubectl create secret docker-registry acr-secret ^
  --docker-server=%ACR_LOGIN_SERVER% ^
  --docker-username=%ACR_NAME% ^
  --docker-password=%DOCKER_PASS% ^
  --docker-email=%DOCKER_EMAIL% ^
  -n %NAMESPACE%

echo.
echo SSL secret...
kubectl create secret generic dashboard-ssl-secret ^
  --from-file=server.key="C:\Users\PC\aks-prj\5g-monitor-deployment\server\server.key" ^
  --from-file=server.crt="C:\Users\PC\aks-prj\5g-monitor-deployment\server\server.crt" ^
  -n %NAMESPACE%

echo.
echo Deploy YAML manifests...
kubectl apply -f argus-server.yaml
kubectl apply -f dashboard-pv-pvc.yaml
kubectl apply -f dashboard.yaml

echo.
echo Đang chờ Pod trong namespace %NAMESPACE% khởi động...
call :wait_for_pods %NAMESPACE%

echo.
echo Mở port-forward truy cập Dashboard tại http://localhost:8110
echo (Nhấn CTRL + C để dừng khi không cần nữa)
kubectl port-forward svc/dashboard-5g-monitoring-service 8110:8110 -n %NAMESPACE%

echo Hoàn tất triển khai free5gc trên AKS!
pause
exit /b

:: ===============================
:: Hàm phụ trợ
:: ===============================
:push_with_retry
set IMAGE=%1
set RETRY=0
:push_retry_loop
docker push %IMAGE%
if %errorlevel% neq 0 (
    set /a RETRY+=1
    if %RETRY% lss 3 (
        echo Push thất bại, thử lại lần %RETRY%...
        timeout /t 5 >nul
        goto push_retry_loop
    ) else (
        echo Push image %IMAGE% thất bại sau 3 lần thử.
        exit /b 1
    )
)
echo Push image %IMAGE% thành công!
exit /b 0

:wait_for_pods
echo Đang đợi Pod khởi động (120 giây)...
timeout /t 120 >nul
echo Hết thời gian chờ, tiếp tục triển khai...
exit /b 0