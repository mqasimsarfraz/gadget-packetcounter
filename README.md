# Packet Counter Gadget

Counts the number of UDP packets sent and displays the count in real-time.

## Prerequisites

- Ensure you have `ig` installed. Follow the installation instructions from the [official website](https://inspektor-gadget.io/docs/latest/reference/install-linux#install-a-specific-release)
- Linux machine and `sudo` privileges.

## Running the Gadget

```bash
sudo -E ig run ghcr.io/mqasimsarfraz/packetcounter
```

or using a different interval (default '10s'):

```bash
sudo -E ig run ghcr.io/mqasimsarfraz/packetcounter --map-fetch-interval 2s
```

## Output

Emits the total number of UDP packets sent at every interval:

```
COMM             PACKETS             
systemd-resolve  3                   
isc-net-0000     2 
```
