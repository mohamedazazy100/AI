# 🚀 Enterprise Infrastructure & Automation Portfolio

This portfolio demonstrates expertise across three critical domains: **Linux System Automation (Bash Scripting)**, **Advanced Network Engineering (CCNA)**, and **Windows Server/Active Directory Management**. The projects emphasize security, scalability, and efficiency in enterprise environments.

---

## 1. 💻 Linux System Administration Automation (`final.sh`)

`final.sh` is a robust, menu-driven Bash shell script engineered to streamline and centralize user and group lifecycle management on Linux servers. The script enhances operational efficiency by replacing multiple complex command-line executions with a single, validated interface.

### Core Functionalities

#### 🧑‍💻 User Management
* **Account Provisioning:** Supports creation with either default settings or advanced, granular customization (UID, Shell, Home Directory, Primary/Secondary Group assignment).
* **Security & Compliance:** Manages account security parameters, including locking accounts (`usermod -L`), and enforcing robust password expiration policies (Min/Max days, Inactivity, Warning days) via the `chage` utility.
* **Account Decommissioning:** Provides controlled deletion options, including the permanent removal of the user's home directory (`userdel -r`).

#### 👥 Group Management
* **Lifecycle Management:** Facilitates the creation, renaming, and deletion of groups with full control over Group ID (GID) assignment.
* **Membership Control:** Offers streamlined functions to add or remove users from supplementary groups (`usermod -aG`, `gpasswd -d`).
* **Querying:** Includes detailed options to display user-defined groups and list members within a specific group.

### Execution

The script is executed as the root user and provides an interactive command-line interface.

```bash
chmod +x final.sh
sudo ./final.sh
