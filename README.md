# 🐝 BeeHost - VHost matching with FFuF

BeeHost is a simple Bash script designed for web server testing using [FFuF](https://github.com/ffuf/ffuf). It automates the process of scanning multiple hosts and ports with customizable parameters, making it a handy tool for security researchers, penetration testers, and web developers.

## Features

-**Customizable**: Easily configure the script with options for HTTP and HTTPS ports, output directory, IP file location, and vhosts file location.
-**Parallel Scanning**: Utilizes FFuF's parallel scanning capabilities to efficiently test multiple hosts and ports simultaneously.
-**Results Compilation**: Generates a final results file containing the concatenated and unique results from all temporary result files.

## Prerequisites

Before using BeeHost, ensure you have the following:

- [FFuF](https://github.com/ffuf/ffuf): The Fast Web Fuzzer
- Bash shell environment

## Usage

```bash
./beehost.sh [-h] [-p ports] [-P http_ports] [-o output_dir] [-i ip_file] [-v vhosts_file]
```


### Parameters

* `-h`: Display help message
* `-p ports`: Specify ports for HTTPS (comma-separated)
* `-P http_ports`: Specify ports for HTTP (comma-separated)
* `-o output_dir`: Specify the output directory
* `-i ip_file`: Specify the location of the IP file
* `-v vhosts_file`: Specify the location of the vhosts file

## Example

<pre><div class="bg-black rounded-md"><div class="flex items-center relative text-gray-200 bg-gray-800 dark:bg-token-surface-primary px-4 py-2 text-xs font-sans justify-between rounded-t-md"><span>bash</span><button class="flex gap-1 items-center"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-sm"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 4C10.8954 4 10 4.89543 10 6H14C14 4.89543 13.1046 4 12 4ZM8.53513 4C9.22675 2.8044 10.5194 2 12 2C13.4806 2 14.7733 2.8044 15.4649 4H17C18.6569 4 20 5.34315 20 7V19C20 20.6569 18.6569 22 17 22H7C5.34315 22 4 20.6569 4 19V7C4 5.34315 5.34315 4 7 4H8.53513ZM8 6H7C6.44772 6 6 6.44772 6 7V19C6 19.5523 6.44772 20 7 20H17C17.5523 20 18 19.5523 18 19V7C18 6.44772 17.5523 6 17 6H16C16 7.10457 15.1046 8 14 8H10C8.89543 8 8 7.10457 8 6Z" fill="currentColor"></path></svg>Copy code</button></div><div class="p-4 overflow-y-auto"><code class="!whitespace-pre hljs language-bash">./beehost.sh -p 443,8443 -P 80,8080 -o ./output -i ./ips.txt -v ./vhosts.txt
</code></div></div></pre>

## Disclaimer

This tool is provided for educational and testing purposes only. Use it at your own risk and responsibility. The developers and contributors are not responsible for any misuse or damage caused by this tool.

## Contributing

Contributions are welcome! If you have suggestions, feature requests, or bug reports, please [open an issue]() or [create a pull request]().

Before contributing, please review the [Contribution Guidelines](https://chat.openai.com/c/CONTRIBUTING.md).

## Tags

* Web Security
* Penetration Testing
* Bash Script
* FFuF
* Web Fuzzer
