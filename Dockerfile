# Use an official Ubuntu as a base image
FROM ubuntu:latest

# Set the working directory inside the container
WORKDIR /usr/src/app

# Set noninteractive mode to avoid debconf issues
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    git \
    python3 \
    python3-venv \
    doxygen \
    lynx \
    clang-format 

# Create and activate a virtual environment
RUN python3 -m venv venv
ENV PATH="/usr/src/app/venv/bin:$PATH"

# Install required Python packages
RUN pip install jinja2 pygments

# Copy the entire project into the container
COPY . .

# Default command to start bash interactively
CMD ["bash"]