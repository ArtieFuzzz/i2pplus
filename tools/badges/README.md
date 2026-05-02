# Badge Generation

## Automated Badge Generation

Run the script to fetch latest badges from shields.io:

```bash
cd tools/badges
./generate-badges.sh
```

This creates SVG files in `tools/badges/`:
- `docker-badge.svg` - Docker Guide (logo: docker)
- `i2psnark-badge.svg` - I2PSnark Download (logo: github)
- `javadocs-badge.svg` - Javadocs Download (logo: github)
- `update-badge.svg` - Update zip Download (logo: github)

## Generated Badges

### Docker Guide
![Docker](docker-badge.svg)

### I2PSnark Download
![I2PSnark](i2psnark-badge.svg)

### Javadocs Download
![Javadocs](javadocs-badge.svg)

### Update zip Download
![Update](update-badge.svg)

## Usage in README.md

```markdown
[![Docker](tools/badges/docker-badge.svg)](docker/README.md)
[![I2PSnark](tools/badges/i2psnark-badge.svg)](https://i2pplus.github.io/installers/i2psnark-standalone.zip)
[![Javadocs](tools/badges/javadocs-badge.svg)](https://i2pplus.github.io/javadoc.zip)
[![Update](tools/badges/update-badge.svg)](https://i2pplus.github.io/i2pupdate.zip)
```