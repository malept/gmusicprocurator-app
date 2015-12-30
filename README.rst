==========================
GMusicProcurator (the App)
==========================

.. image:: https://travis-ci.org/malept/gmusicprocurator-app.svg?branch=master
    :target: https://travis-ci.org/malept/gmusicprocurator-app

Embeds the web frontend of a running GMusicProcurator_ web application inside
of an Electron_ shell.

.. _GMusicProcurator: https://gmusicprocurator.readthedocs.org/
.. _Electron: http://electron.atom.io/

Building
--------

1. Install librsvg (specifically on Debian/Ubuntu, ``librsvg2-bin``).
2. On OSX, install ``makeicns`` (e.g, via Homebrew). On other OSes, install
   ``icnsutils`` (specifically, the package that installs ``png2icns``).
3. To build for Windows, install ``icoutils`` (which generates the icon for the
   Windows binary).
4. To build for Windows on a non-Windows build machine, install ``wine``, to
   properly modify the Windows binaries.
5. Install `GNU Make`_ if it's not already on your system.
6. Clone this Git repository.
7. Run ``npm install``.
8. Build the app for your OS and architecture, see the ``Makefile`` for the
   specific target. For example, for Linux on a 64 bit architecture, run
   ``make dist-linux-x64``. If you run ``make`` without a target, distributions
   for all supported OSes will be built.

Running
-------

1. `Install and run GMusicProcurator`_ (with web UI frontend) on the target OS.
2. Run the app in your target OS.

.. _Install and run GMusicProcurator:
    https://gmusicprocurator.readthedocs.org/en/latest/install.html
.. _GNU Make: https://www.gnu.org/software/make/
