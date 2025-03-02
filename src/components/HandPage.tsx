import { useEffect, useState } from "react";
import { useGestureWebsocket } from "../hook/useGestureWebSocket";
import { invoke } from "@tauri-apps/api/core";


//1. map the gestures to the mouse mode
//2. detect the mode we are in and invoke that command
//3. calculating the distance between the two points

const HandPage = () => {
  const { parsedHands, isConnected, setIsConnected } = useGestureWebsocket();
  const [isMoving, setIsMoving] = useState(false);
  const [position, setPosition] = useState({ x: 0, y: 0 });

  //1. find the gesture to match the mode
  useEffect(() => {
    setIsMoving(false);
    if (!parsedHands.length) return;
    parsedHands.forEach((hand) => {
      hand.gestures.forEach((gesture) => {
        if (gesture.name === "U_SIGN") {
          const indexFinger = hand.hand.keypoints.filter(
            (keypoint) => keypoint.name === "index_finger_tip"
          );
          setPosition({
             x: Math.round(indexFinger[0].x),
              y: Math.round(indexFinger[0].y),

          });
          setIsMoving(true);
        }
      });
    });
  }, [parsedHands]);

  //2. set up mode to invoke the command
  useEffect(() => {
    if (isMoving) {
      console.log("Moving to", position); 
      invoke("move_to", { x: position.x, y: position.y });
    }
  }, [isMoving]);

  const handleConnection = () => {
    // setIsConnected(!isConnected);
    setIsConnected((prev) => !prev);
  };

  return (
    <div className="w-full h-screen flex items-center justify-center  p-4">
      <h1 className="text-6xl">Hand.</h1>

      <div className="absolute bottom-8 left-8 bg-white p-4 rounded shadow">
        {isConnected ? (
          <p className="text-2xl">
            Current Gesture:{" "}
            {parsedHands.length
              ? parsedHands[0].gestures[0].name
              : "🪤 waiting..."}
          </p>
        ) : (
          <p className="text-2xl">🐁 Please connecting....</p>
        )}

        <button
          className="mt-2 px-4 py-2 bg-blue-500 text-white rounded"
          onClick={handleConnection}
        >
          {isConnected ? "Disconnect" : "Connect"}
        </button>
      </div>
    </div>
  );
};

export default HandPage;
