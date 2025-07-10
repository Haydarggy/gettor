#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
GetTor Main Runner
==================

This script starts and manages all GetTor services:
- SMTP service
- XMPP service  
- Twitter service
- HTTP service

Usage:
    python run_gettor.py [service_name]
    
    service_name options:
    - smtp: Start SMTP service only
    - xmpp: Start XMPP service only
    - twitter: Start Twitter service only
    - http: Start HTTP service only
    - all: Start all services (default)
"""

import sys
import os
import time
import threading
import logging
import argparse
from multiprocessing import Process

# Add the gettor module to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'gettor'))

import gettor.smtp as smtp_module
import gettor.xmpp as xmpp_module
import gettor.twitter as twitter_module
import gettor.http as http_module

def setup_logging():
    """Setup basic logging configuration."""
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )

def run_smtp():
    """Run SMTP service."""
    try:
        logging.info("Starting SMTP service...")
        smtp_bot = smtp_module.SMTPBot('smtp.cfg')
        smtp_bot.start()
    except Exception as e:
        logging.error("Error starting SMTP service: %s" % str(e))

def run_xmpp():
    """Run XMPP service."""
    try:
        logging.info("Starting XMPP service...")
        xmpp_bot = xmpp_module.XMPPBot('xmpp.cfg')
        xmpp_bot.start()
    except Exception as e:
        logging.error("Error starting XMPP service: %s" % str(e))

def run_twitter():
    """Run Twitter service."""
    try:
        logging.info("Starting Twitter service...")
        twitter_bot = twitter_module.TwitterBot('twitter.cfg')
        twitter_bot.start()
    except Exception as e:
        logging.error("Error starting Twitter service: %s" % str(e))

def run_http():
    """Run HTTP service."""
    try:
        logging.info("Starting HTTP service...")
        http_server = http_module.HTTPServer('http.cfg')
        http_server.start()
    except Exception as e:
        logging.error("Error starting HTTP service: %s" % str(e))

def main():
    """Main function to parse arguments and start services."""
    parser = argparse.ArgumentParser(description='GetTor Service Runner')
    parser.add_argument('service', nargs='?', default='all',
                       choices=['smtp', 'xmpp', 'twitter', 'http', 'all'],
                       help='Service to start (default: all)')
    
    args = parser.parse_args()
    
    setup_logging()
    
    processes = []
    
    try:
        if args.service == 'smtp' or args.service == 'all':
            p = Process(target=run_smtp)
            p.start()
            processes.append(p)
            
        if args.service == 'xmpp' or args.service == 'all':
            p = Process(target=run_xmpp)
            p.start()
            processes.append(p)
            
        if args.service == 'twitter' or args.service == 'all':
            p = Process(target=run_twitter)
            p.start()
            processes.append(p)
            
        if args.service == 'http' or args.service == 'all':
            p = Process(target=run_http)
            p.start()
            processes.append(p)
        
        logging.info("GetTor services started successfully!")
        logging.info("Press Ctrl+C to stop all services")
        
        # Wait for all processes
        for p in processes:
            p.join()
            
    except KeyboardInterrupt:
        logging.info("Stopping GetTor services...")
        for p in processes:
            p.terminate()
            p.join()
        logging.info("All services stopped.")

if __name__ == '__main__':
    main()