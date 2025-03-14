#!/bin/bash

echo "Building Python container..."
docker build -t plant_plot_image .

echo "running python container.."
docker run --rm -v ~/LINUX_Course_Project/Work/Q5/:/app plant_plot_image --plant "Sunflower" --height 120 125 130 135 --leaf_count 50 55 60 65 --dry_weight 5.0 5.5 6.0 6.5

echo "building java container.."
docker build -t java_watermark_image java_watermark/

echo "running java container for watermarking.."
docker run --rm -v ~/LINUX_Course_Project/Work/Q5/:/app java_watermark_image /app "Maria Atieh - 318087711 & Noam Lewkovich - 206436311"

echo "cleaning up containers.."
docker rm -f $(docker ps -aq) 2>/dev/null

echo "cleaning up imgs.."
docker image prune -f

echo "All done!"

