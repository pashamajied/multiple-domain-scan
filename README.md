<h1 align="center">MULTIPLE-DOMAIN-SCAN</h1>

<p align="center"><i>Streamline your security assessments with effortless scanning.</i></p>

<p align="center">
  <img src="https://img.shields.io/badge/last%20commit-december%202024-blue" />
  <img src="https://img.shields.io/badge/shell-100%25-blue" />
  <img src="https://img.shields.io/badge/languages-1-grey" />
</p>


<p align="center"><i>Built with the tools and technologies:</i></p>

<p align="center">
  <img src="https://img.shields.io/badge/-GNU%20Bash-4EAA25?logo=gnubash&logoColor=white" />
<a href="https://github.com/projectdiscovery" target="_blank">
  <img src="https://img.shields.io/badge/GitHub-projectdiscovery-181717?style=flat-square&logo=github" alt="GitHub ProjectDiscovery">
</a>
</p>

---

<p align="center">
  <a href="#overview">Overview</a> •
  <a href="#kenapa-multiple-domain-scan">Kenapa multiple-domain-scan</a> •
  <a href="#prerequisites">Prerequisites</a> •
  <a href="#instalasi-dan-jalankan">Instalasi</a> •
  <a href="#output-skrip">Output Skrip</a> 
</p>

---

## Overview

Pemindaian Beberapa Domain adalah alat otomatisasi canggih yang dirancang untuk merampingkan proses penilaian keamanan untuk beberapa domain.

## **Kenapa multiple-domain-scan?**

Proyek ini meningkatkan efisiensi pengujian penetrasi dengan mengotomatiskan pencacahan subdomain dan pemindaian kerentanan. Fitur-fitur utamanya meliputi:

- 🔍 **Pemindaian Otomatis**: Melakukan pencacahan subdomain dan penilaian kerentanan dengan mudah di berbagai domain.
- ⚙️ **Integrasi Alat**: Memanfaatkan alat populer seperti **Subfinder**, **HTTPX**, dan **Nuclei** untuk hasil yang andal.
- 📂 **Hasil Terorganisir**: Hasil dikategorikan dengan rapi ke dalam direktori khusus untuk setiap domain, menyederhanakan analisis.
- 🚀 **Penginstalan yang Mudah**: Satu skrip mengatur semua alat penting, menghemat waktu dan tenaga Anda.
- 📲 **Pemberitahuan Telegram**: Dapatkan pembaruan waktu nyata tentang hasil pemindaian secara langsung melalui Telegram untuk komunikasi yang lebih baik.

---

## Prerequisites

This project requires the following dependencies:

- **Programming Language**: Shell  
- **Package Manager**: Bash
- **Tools**: Subfinder, HTTPX, Nuclei
- **Telegram Chat ID**: For notifications
- **Telegram Bot Token**: For notifications
- **Domain List**: A list of domains to scan


---

### Instalasi dan Jalankan

1. **Unduh skrip:**<br>
    Anda dapat dengan mudah menginstal dan menjalankan skrip ini dengan menggunakan perintah berikut pada terminal:

    ```bash
    wget -q https://raw.githubusercontent.com/pashamajied/multiple-domain-scan/main/install-first.sh && bash install-first.sh
    ```

    Perintah ini akan mengunduh skrip `install-first.sh` dari repositori GitHub dan menjalankannya di terminal Anda. Skrip ini akan secara otomatis menginstal alat-alat yang diperlukan seperti `unzip`, `wget`, `curl`, `subfinder`, `httpx`, dan `nuclei` sebelum melanjutkan ke langkah selanjutnya.

2. **Jalankan:**<br>
    Setelah instalasi selesai, Anda dapat menggunakan skrip `runm` untuk melakukan scan pada beberapa domain. Skrip ini dapat dijalankan dengan perintah berikut:

    ```bash
    runm
    ```

3. **Pemindaian Domain**<br>
    Setelah skrip dijalankan, Anda dapat memindai beberapa domain dengan mudah. Cukup masukkan daftar domain yang ingin Anda pindai, pisahkan dengan spasi, dan ikuti petunjuk pada layar:
    ```bash
    Multiple Domain Scan
    Masukkan daftar domain yang akan di-scan (pisahkan dengan spasi): domain1.com domain2.com domain3.com
    ```

---

### Output Skrip

Skrip ini akan secara otomatis:

1. Memulai pemindaian subdomain untuk setiap domain menggunakan Subfinder.
2. Menyaring dan mengidentifikasi subdomain aktif menggunakan HTTPX.
3. Melakukan pemindaian kerentanan menggunakan Nuclei untuk subdomain aktif yang ditemukan.

Hasil pemindaian akan disimpan dalam direktori masing-masing domain di `/root/pentest/tanngal-bulan-tahun/domain`.

Contoh: `/root/pentest/17-08-1945/domain1.com`
