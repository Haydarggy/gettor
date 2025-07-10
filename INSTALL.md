# GetTor Installation Guide

This guide will help you install and configure GetTor, a system for distributing Tor Browser through multiple channels to circumvent censorship.

## Prerequisites

- Python 2.7 or Python 3.x
- pip (Python package installer)
- Git

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/torproject/gettor.git
cd gettor
```

### 2. Install Dependencies

```bash
pip install -r requirements.txt
```

Or install using setup.py:

```bash
python setup.py install
```

### 3. Create Directory Structure

```bash
mkdir -p log
mkdir -p lang
mkdir -p providers
```

## Configuration

### 1. Core Configuration

Edit `core.cfg`:

```ini
[general]
basedir: /full/path/to/gettor
db: gettor.db

[links]
dir: /full/path/to/gettor/providers/
os: linux,windows,osx
locales: es,en,fa,pt,ru,tr,zh

[log]
dir: /full/path/to/gettor/log/
level: DEBUG
```

### 2. SMTP Configuration

Edit `smtp.cfg`:

```ini
[general]
basedir: /full/path/to/gettor
mirrors: /full/path/to/gettor/mirrors-list.txt
our_domain: torproject.org
core_cfg: /full/path/to/gettor/core.cfg

[blacklist]
cfg: /full/path/to/gettor/blacklist.cfg
max_requests: 3
wait_time: 20

[i18n]
dir: /full/path/to/gettor/lang/

[log]
level: DEBUG
dir: /full/path/to/gettor/log/
```

### 3. XMPP Configuration

Edit `xmpp.cfg`:

```ini
[account]
username: gettor@jabber.org
password: YOUR_PASSWORD_HERE
server: jabber.org

[general]
basedir: /full/path/to/gettor
mirrors: /full/path/to/gettor/mirrors-list.txt
core_cfg: /full/path/to/gettor/core.cfg

[blacklist]
cfg: /full/path/to/gettor/blacklist.cfg
max_requests: 3
wait_time: 20

[i18n]
dir: /full/path/to/gettor/lang/

[log]
level: DEBUG
dir: /full/path/to/gettor/log/
```

### 4. Twitter Configuration

Edit `twitter.cfg`:

```ini
[access_config]
api_key: YOUR_TWITTER_API_KEY_HERE
api_secret: YOUR_TWITTER_API_SECRET_HERE
access_token: YOUR_TWITTER_ACCESS_TOKEN_HERE
token_secret: YOUR_TWITTER_TOKEN_SECRET_HERE

[general]
basedir: /full/path/to/gettor
mirrors: /full/path/to/gettor/mirrors-list.txt
core_cfg: /full/path/to/gettor/core.cfg

[blacklist]
cfg: /full/path/to/gettor/blacklist.cfg
max_requests: 3
wait_time: 20

[i18n]
dir: /full/path/to/gettor/lang/

[log]
level: DEBUG
dir: /full/path/to/gettor/log/
```

### 5. Blacklist Configuration

Edit `blacklist.cfg`:

```ini
[general]
basedir: /full/path/to/gettor
db: blacklist.db

[log]
dir: /full/path/to/gettor/log/
level: DEBUG
```

## Setting Up Providers

### Dropbox Setup

1. Create a Dropbox app at https://www.dropbox.com/developers/apps
2. Edit `upload/dropbox.cfg`:

```ini
[app]
access_token: YOUR_DROPBOX_ACCESS_TOKEN
```

### Google Drive Setup

1. Create a Google Cloud project and enable Drive API
2. Download credentials JSON file
3. Edit `upload/drive.cfg`:

```ini
[app]
credentials_file: /path/to/credentials.json
```

### GitHub Setup

1. Create a GitHub personal access token
2. Edit `upload/github.cfg`:

```ini
[app]
access_token: YOUR_GITHUB_ACCESS_TOKEN
user: YOUR_GITHUB_USERNAME
repo: YOUR_REPO_NAME
```

## Database Setup

Initialize the databases:

```bash
python scripts/create_db.py
```

## Running GetTor

### Start All Services

```bash
python run_gettor.py all
```

### Start Individual Services

```bash
# SMTP only
python run_gettor.py smtp

# XMPP only
python run_gettor.py xmpp

# Twitter only
python run_gettor.py twitter

# HTTP only
python run_gettor.py http
```

## Updating Mirrors

### Upload to Providers

```bash
# Upload to Dropbox
python upload/bundles2dropbox.py

# Upload to Google Drive
python upload/bundles2drive.py

# Upload to GitHub
python upload/bundles2github.py
```

### Update Mirror Lists

```bash
python get_mirrors.py
```

## Monitoring

Check logs in the `log/` directory:

- `smtp.log` - SMTP service logs
- `xmpp.log` - XMPP service logs
- `twitter.log` - Twitter service logs
- `http.log` - HTTP service logs

## Troubleshooting

### Common Issues

1. **Permission Errors**: Make sure all paths in config files are accessible
2. **Twitter API Errors**: Verify your Twitter API credentials
3. **XMPP Connection Issues**: Check username/password and server settings
4. **Database Errors**: Ensure database files are writable

### Getting Help

- Check the logs for detailed error messages
- Open an issue on the GitHub repository
- Contact the Tor Project for support

## Security Considerations

- Keep your API keys and credentials secure
- Regularly update dependencies
- Monitor logs for suspicious activity
- Use strong passwords for accounts
- Consider running services in containers or separate environments

## Contributing

See the main README.md for information on how to contribute to GetTor.