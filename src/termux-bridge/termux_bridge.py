import time
import os

def main():
    print("🚀 OGUF Termux Bridge starting...")
    print(f"Environment: {os.uname().sysname}")
    while True:
        print("Bridge active - Monitoring Moto G35 status...")
        time.sleep(10)

if __name__ == "__main__":
    main()
