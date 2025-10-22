# Hướng dẫn triển khai AKS bằng Terraform

---

## 📋 Yêu cầu hệ thống

- Windows 10/11
- Quyền Administrator

---

## Cài đặt Kubectl

### Dùng Chocolatey

**Bước 1: Cài đặt Chocolatey**

Mở **PowerShell as Administrator** và chạy:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

**Bước 2: Cài kubectl**

```powershell
choco install kubernetes-cli
```

### Kiểm tra cài đặt

```powershell
kubectl version --client
```

---

## Cài đặt Terraform

### Dùng Chocolatey

```powershell
choco install terraform
```

### Kiểm tra cài đặt

```powershell
terraform --version
```

---

## Cài đặt Azure CLI

### Download MSI Installer

1. Tải từ: https://aka.ms/installazurecliwindows
2. Chạy file `.msi` và làm theo hướng dẫn
3. Restart Terminal sau khi cài

### Kiểm tra cài đặt

```powershell
az --version
```

---

## Đăng nhập Azure

Sau khi cài đặt, đăng nhập vào Azure:

```powershell
az login
```

Trình duyệt sẽ mở để đăng nhập. Sau khi đăng nhập thành công:

```powershell
# Xem danh sách subscriptions
az account list --output table

# Set subscription mặc định
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Xem subscription hiện tại
az account show
```

---

## Cấu hình Kubectl với AKS

Để kubectl có thể kết nối với AKS cluster:

```powershell
# Lấy credentials của AKS cluster
az aks get-credentials --resource-group YOUR_RESOURCE_GROUP --name YOUR_CLUSTER_NAME

# Kiểm tra kết nối
kubectl get nodes
```

---

## Tài liệu tham khảo

- [Kubectl Documentation](https://kubernetes.io/docs/reference/kubectl/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure CLI Documentation](https://docs.microsoft.com/en-us/cli/azure/)
- [AKS Documentation](https://docs.microsoft.com/en-us/azure/aks/)

---

## Next Steps

Sau khi cài đặt xong, bạn có thể:

1. **Tạo AKS cluster bằng Terraform:**
```bash
terraform init
terraform plan
terraform apply
```
