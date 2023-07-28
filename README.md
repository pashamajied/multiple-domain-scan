# Multiple Domain Scan

Multiple Domain Scan adalah skrip bash sederhana yang digunakan untuk memudahkan proses instalasi dan pemindaian beberapa domain secara otomatis menggunakan beberapa alat populer, yaitu Subfinder, HTTPX, dan Nuclei.

## Cara Penggunaan

### Instalasi

Anda dapat dengan mudah menginstal dan menjalankan skrip ini dengan menggunakan perintah berikut pada terminal:

```bash
curl https://raw.githubusercontent.com/pashamajied/multiple-domain-scan/main/install-first.sh | bash
```

Perintah ini akan mengunduh skrip `install-first.sh` dari repositori GitHub dan menjalankannya di terminal Anda. Skrip ini akan secara otomatis menginstal alat-alat yang diperlukan seperti `unzip`, `wget`, `curl`, `subfinder`, `httpx`, dan `nuclei` sebelum melanjutkan ke langkah selanjutnya.

### Jalankan
Setelah instalasi selesai, Anda dapat menggunakan skrip `runm` untuk melakukan scan pada beberapa domain. Skrip ini dapat dijalankan dengan perintah berikut:

```bash
runm
```

### Pemindaian Domain

Setelah skrip dijalankan, Anda dapat memindai beberapa domain dengan mudah. Cukup masukkan daftar domain yang ingin Anda pindai, pisahkan dengan spasi, dan ikuti petunjuk pada layar:

```bash
Multiple Domain Scan

Masukkan daftar domain yang akan di-scan (pisahkan dengan spasi): domain1.com domain2.com domain3.com
```

Skrip ini akan secara otomatis:

1. Memulai pemindaian subdomain untuk setiap domain menggunakan Subfinder.
2. Menyaring dan mengidentifikasi subdomain aktif menggunakan HTTPX.
3. Melakukan pemindaian kerentanan menggunakan Nuclei untuk subdomain aktif yang ditemukan.

Hasil pemindaian akan disimpan dalam direktori masing-masing domain di `/root/pentest/tanngal-bulan-tahun/domain`.

Contoh: `/root/pentest/17-08-1945/domain1.com`

