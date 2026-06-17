# Use explicit Python version required by Simumatik drivers
FROM python:3.11-slim

# Install git to pull the official gateway repository
RUN apt-get update && apt-get install -y \
    git \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Set up work directory
WORKDIR /workspace

# Clone the official Simumatik Gateway
RUN git clone https://github.com/Simumatik/simumatik-gateway.git

# Install all mandatory Simumatik Gateway dependencies
RUN pip install --no-cache-dir -r simumatik-gateway/requirements
    
# Install pyniryo for robot control and roslibpy for background socket management
RUN pip install --no-cache-dir pyniryo roslibpy

# Copy your script folder into the container
COPY ./app /workspace/app

ENV PYTHONUNBUFFERED=1

# Run the Simumatik gateway and your controller script concurrently
CMD ["sh", "-c", "python simumatik-gateway/src/gateway.py debug & python app/niryo_telemetry.py"]
