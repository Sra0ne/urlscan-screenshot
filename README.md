# URLScan.io Screenshot and Result Retrieval

This Ruby script interacts with the [urlscan.io](https://urlscan.io/) API to scan a provided URL, retrieve a screenshot, and save the scan result in JSON format.

## Prerequisites

- Ruby installed on your system
- Free API key from urlscan.io (Set as an environment variable: `urlsckey`)

## Usage

1. Run the script:

   ```bash
    ruby urlscr.rb
2.Enter the URL when prompted.

3.Wait for the scan to complete.

4.The script will save the screenshot as uuid.png and the scan result as uuid-result.json in the current directory.

## Configuration
Set the urlscan.io API key as an environment variable:


    
    export urlsckey="your_api_key"

This script has no dependencies and only uses the Ruby standard library

## Contributing
Feel free to contribute or expand by opening issues or submitting pull requests.
