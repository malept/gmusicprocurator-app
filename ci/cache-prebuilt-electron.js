#!/usr/bin/env node

const download = require('electron-download');
const fs = require('fs');
const path = require('path');
const pify = require('pify');

const packageJSON = require(path.resolve(__dirname, '..', 'package.json'));

Promise.all(['x64', 'ia32', 'armv7l'].map(arch => {
  return pify(download)({
      version: packageJSON.devDependencies['electron-prebuilt-compile'],
      arch,
      cache: `${process.env.TRAVIS_BUILD_DIR || '/tmp'}/.electron`,
      quiet: true
    });
})).catch(err => {
  throw err;
});
