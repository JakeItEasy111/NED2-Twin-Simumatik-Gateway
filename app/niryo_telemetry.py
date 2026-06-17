import os
import time
from pyniryo import NiryoRobot

# Pull target IP from the docker-compose environment settings
robot_ip = os.environ.get("ROBOT_IP", "10.10.10.10") 

print(f"Connecting directly to physical Niryo Robot at {robot_ip}...")
try:
    robot = NiryoRobot(robot_ip)
    robot.calibrate_auto()
    
    while True:
        # Loop handles safely parsing commands sent from Simumatik 
        # via the local Gateway bridge
        current_joints = robot.get_joints()
        time.sleep(0.05) # Cap at ~20Hz
        
except Exception as e:
    print(f"Hardware connection failed: {e}")
