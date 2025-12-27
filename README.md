# OSF/1 v2.0 Bourne Shell Port for Linux x86_64

This project is a successful port of the historical **OSF/1 v2.0 Bourne Shell** (derived from DEC/OSF/System V) to modern 64-bit Linux. It focuses on software preservation, 64-bit stability, and modernizing memory management while maintaining the classic shell behavior.

## ✨ Features of this Port
*   **64-bit Stable**: Extensive refactoring of `mode.h` and internal macros (e.g., `Rcheat`) to use `intptr_t`, preventing pointer truncation on 64-bit systems.
*   **Modern Memory**: Replaced the legacy `sbrk(2)`-based custom allocator with standard `malloc`/`free` wrappers in `blok.c`.
*   **Stable Stack**: Refactored `stak.c` to use `realloc` for dynamic stack growth.
*   **POSIX Shims**: A lightweight compatibility layer (`osf_sh_shims.h`) to bridge OSF/1 proprietary headers to standard Linux/POSIX APIs.
*   **Bug Fixes**: Resolved critical issues like the 2GB stack probe allocation and infinite recursion in pipeline forks.

## 🚀 Getting Started

### Building
The project contains a standalone `Makefile`. Simply run:
```bash
make
```

### Running the Stress Test
To verify the port on your system:
```bash
./stress.sh
```

## 📜 Licensing & Legal Disclaimer

### Original Code
This repository contains historical source code originally developed by:
*   **Digital Equipment Corporation (DEC)**
*   **Open Software Foundation, Inc. (OSF)**
*   **International Business Machines Corp. (IBM)**
*   **AT&T / Bell Telephone Laboratories**

All original copyright headers have been preserved. This code is provided for **educational, research, and historical preservation purposes only**. 

### Porting Modifications
The modifications, shims, and build system changes created for this port (2025) are licensed under the **0BSD License**. See the `LICENSE` file for details.

---
*Developed by Mario (@wordatet) in collaboration with Gemini and Claude - A labor of love for UNIX history.*
