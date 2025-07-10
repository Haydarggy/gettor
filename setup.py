#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
GetTor Setup Script
===================

GetTor is a program for serving Tor and related files over SMTP, XMPP, Twitter, 
and HTTP, thus avoiding direct and indirect censorship of Tor's software.

This setup script installs GetTor and its dependencies.
"""

from setuptools import setup, find_packages
import os

# Read the contents of README file
this_directory = os.path.abspath(os.path.dirname(__file__))
with open(os.path.join(this_directory, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

# Read requirements
with open('requirements.txt') as f:
    requirements = [line.strip() for line in f if line.strip() and not line.startswith('#')]

setup(
    name='gettor',
    version='2.0.0',
    description='Tor distribution system via multiple channels (SMTP, XMPP, Twitter, HTTP)',
    long_description=long_description,
    long_description_content_type='text/markdown',
    author='Israel Leiva',
    author_email='ilv@torproject.org',
    url='https://github.com/torproject/gettor',
    license='BSD',
    packages=find_packages(),
    include_package_data=True,
    install_requires=requirements,
    python_requires='>=2.7',
    classifiers=[
        'Development Status :: 4 - Beta',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Topic :: Internet :: WWW/HTTP',
        'Topic :: Communications :: Email',
        'Topic :: Security :: Cryptography',
    ],
    entry_points={
        'console_scripts': [
            'gettor-smtp=gettor.smtp:main',
            'gettor-xmpp=gettor.xmpp:main', 
            'gettor-twitter=gettor.twitter:main',
            'gettor-http=gettor.http:main',
        ],
    },
    keywords='tor privacy anonymity censorship-circumvention',
    zip_safe=False,
)