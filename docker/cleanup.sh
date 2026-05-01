#!/bin/bash
#
# I2P+ Docker Cleanup Script
# Cleans up containers, images, volumes, and cache files
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

show_help() {
    echo "I2P+ Docker Cleanup Script"
    echo "==========================="
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --all, -a                    Clean everything (containers, images, volumes, build cache)"
    echo "  --cleanall, -ca              Stop and clean everything (stop containers first, then clean)"
    echo "  --stop, -s                   Stop any running I2P+ containers only"
    echo "  --containers, -c             Clean stopped containers"
    echo "  --images, -i                 Clean unused images"
    echo "  --volumes, -v                Clean unused volumes"
    echo "  --build, -b                  Clean Docker build cache"
    echo "  --help, -h                   Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --all           # Clean everything"
    echo "  $0 --cleanall      # Stop containers first, then clean everything"
    echo "  $0 -c -i           # Clean containers and images only"
    echo "  $0 -b              # Clean build cache only"
}

# Function to print status
print_status() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if docker is available
if ! command -v docker &> /dev/null; then
    print_error "Docker not found. Please install Docker first."
    exit 1
fi

# Parse arguments
CLEAN_ALL=false
CLEAN_CONTAINERS=false
CLEAN_IMAGES=false
CLEAN_VOLUMES=false
CLEAN_BUILD=false
STOP_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --all|-a)
            CLEAN_ALL=true
            ;;
        --cleanall|-ca)
            CLEAN_ALL=true
            STOP_ONLY=true
            ;;
        --stop|-s)
            STOP_ONLY=true
            ;;
        --containers|-c)
            CLEAN_CONTAINERS=true
            ;;
        --images|-i)
            CLEAN_IMAGES=true
            ;;
        --volumes|-v)
            CLEAN_VOLUMES=true
            ;;
        --build|-b)
            CLEAN_BUILD=true
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
    shift
done

# Default: show help if no options specified
if [ "$CLEAN_ALL" = false ] && [ "$CLEAN_CONTAINERS" = false ] && [ "$CLEAN_IMAGES" = false ] && [ "$CLEAN_VOLUMES" = false ] && [ "$CLEAN_BUILD" = false ] && [ "$STOP_ONLY" = false ]; then
    show_help
    exit 0
fi

echo -e "${YELLOW}I2P+ Docker Cleanup${NC}"
echo "===================="

# Stop running containers (for --stop and --cleanall)
if [ "$STOP_ONLY" = true ]; then
    echo ""
    echo "Stopping any running I2P+ containers..."
    RUNNING=$(docker ps -q 2>/dev/null || true)
    if [ -n "$RUNNING" ]; then
        docker stop $RUNNING 2>/dev/null || true
        print_status "Stopped all running containers"
    else
        print_status "No running containers to stop"
    fi

    if [ "$CLEAN_ALL" = false ]; then
        # --stop only, don't clean
        echo ""
        print_status "Done! Containers stopped (use --all to clean after stopping)"
        exit 0
    fi
fi

# Clean containers
if [ "$CLEAN_CONTAINERS" = true ] || [ "$CLEAN_ALL" = true ]; then
    echo ""
    echo "Cleaning containers..."
    CONTAINERS=$(docker ps -aq 2>/dev/null || true)
    if [ -n "$CONTAINERS" ]; then
        docker stop $CONTAINERS 2>/dev/null || true
        docker rm $CONTAINERS 2>/dev/null || true
        print_status "Stopped and removed all containers"
    else
        print_status "No containers to clean"
    fi

    # Clean stopped containers
    docker container prune -f 2>/dev/null || true
fi

# Clean images
if [ "$CLEAN_IMAGES" = true ] || [ "$CLEAN_ALL" = true ]; then
    echo ""
    echo "Cleaning images..."
    # Keep i2pplus image if it exists
    docker image prune -a -f 2>/dev/null || true
    print_status "Cleaned unused images"
fi

# Clean volumes
if [ "$CLEAN_VOLUMES" = true ] || [ "$CLEAN_ALL" = true ]; then
    echo ""
    echo "Cleaning volumes..."
    docker volume prune -f 2>/dev/null || true
    print_status "Cleaned unused volumes"
fi

# Clean build cache
if [ "$CLEAN_BUILD" = true ] || [ "$CLEAN_ALL" = true ]; then
    echo ""
    echo "Cleaning build cache..."
    docker builder prune -af 2>/dev/null || true
    print_status "Cleaned build cache"
fi

# Clean system-wide
if [ "$CLEAN_ALL" = true ]; then
    echo ""
    echo "Cleaning system-wide Docker resources..."
    docker system prune -af 2>/dev/null || true
    print_status "Cleaned system-wide Docker resources"
fi

echo ""
echo -e "${GREEN}Cleanup complete!${NC}"
echo ""

# Show remaining resources
echo "Remaining resources:"
echo "--------------------"
docker ps -a 2>/dev/null || true
echo ""
docker images 2>/dev/null || true

echo ""
print_status "Done!"