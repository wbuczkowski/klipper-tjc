.. _display-control-application-communication:

Display Application Communication
=================================
The Display Controll Application creates the link between Klipper, using the Moonraker JSON RPC API, and the TJC Display.

.. uml::

    Moonraker <--> "Display Control Application" : Websocket\n(JSON-RPC)
    "Display Control Application" <--> "TJC Display" : Serial Interface\n(python-dgus)