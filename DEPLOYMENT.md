## Deployment

### Basic Setup
- At some point I worked through this setup mainly using stuff here [here](https://gemini.google.com/app/dea71b81c3a4162f).
We have ownership of the url `pl-streamer.link` which is setup in Route53 to point to an EC2 instance.
We created OpenSSL certs using `certbot` (also detailed in the chat above). I'm pretty sure we should get a warning when expiration of these is approaching.

### Pushing updates


To deploy updates:

1. SSH into the server:
   ```bash
   ssh -i <path/to/pl-wt.pem>.pem ubuntu@pl-streamer.link
   ```
   - If that URL gets remapped to some other place you can use the External IP itself: `ssh -i <path/to/pl-wt.pem>.pem ubuntu@3.22.49.87`

2. Run the deployment script:
   ```bash
   cd ~/moq
   chmod +x DEPLOY_PROD.sh
   ./DEPLOY_PROD.sh
   ```

The script will:
- Pull the latest changes from main
- Build the release version
- Stop the systemd service
- Copy the executable to /opt/pl-moq
- Set appropriate permissions
- Restart the service

Username for git is `juanBerger` and password is located here: `/Users/juanaboites/dev/postlink/dev/postlink-credentials/ec2-keys/pl-wt-updater-git-pat`

Current pem path:
- ssh -i ~/dev/postlink/dev/postlink-credentials/ec2-keys/pl-wt.pem ubuntu@pl-streamer.link

Some basic systemctl commands:
- sudo systemctl status pl-moq.service
- sudo systemctl stop pl-moq.service
- sudo systemctl start pl-moq.service
- sudo journalctl -n 20 -u pl-moq.service
- sudo journalctl -n 20 -f -u pl-moq.service

Anything written to stdout by the server gets saved in a log by systemd.
Logs are written to `/var/log/journal`
Without size limits this can grow very large so there is a 300MB limit set here:
`sudo nano /etc/systemd/journald.conf`

We can also check the current size of the logs with:
`journalctl --disk-usage`
And delete them with (dont just delete the files):
`sudo journalctl --vacuum-size=1M`

The config file for this service is lcated here:
`/etc/systemd/system/pl-moq.service`
