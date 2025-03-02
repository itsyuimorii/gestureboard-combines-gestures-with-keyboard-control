import { useEffect, useState, useRef } from "react";
import { useGestureWebsocket } from "../hook/useGestureWebSocket";
import { invoke } from "@tauri-apps/api/core";

const HandPage = () => {
  const { parsedHands, isConnected, setIsConnected } = useGestureWebsocket();
  const [position, setPosition] = useState({ x: 0, y: 0 });
  const lastPosition = useRef({ x: 0, y: 0 });
  const isMovingRef = useRef(false);
  const animationFrameRef = useRef<number | null>(null);

  // 🔹 Process WebSocket messages efficiently (Throttle updates)
  useEffect(() => {
    if (!parsedHands.length) return;

    parsedHands.forEach((hand) => {
      hand.gestures.forEach((gesture) => {
        if (gesture.name === "U_SIGN") {
          const indexFinger = hand.hand.keypoints.find(
            (keypoint) => keypoint.name === "index_finger_tip"
          );

          if (indexFinger) {
            const newPosition = {
              x: Math.round(indexFinger.x),
              y: Math.round(indexFinger.y),
            };

            if (
              newPosition.x !== lastPosition.current.x ||
              newPosition.y !== lastPosition.current.y
            ) {
              setPosition(newPosition);
              isMovingRef.current = true;
            }
          }
        }
      });
    });
  }, [parsedHands]); // ✅ Runs only when `parsedHands` updates

  // 🔹 Main loop using requestAnimationFrame (Prevents excessive updates)
  useEffect(() => {
    const moveCursor = () => {
      if (!isMovingRef.current) {
        // lastPosition.current = { x: 0, y: 0 };
        return;
      }

      let deltaX = position.x - lastPosition.current.x;
      console.log(position)
      let deltaY = position.y - lastPosition.current.y;
      if (Math.abs(deltaX) > 100) {
        deltaX = 0;
        deltaY = 0;
      }
      if (Math.abs(deltaY) > 100) {
        deltaX = 0;
        deltaY = 0;
      }

      // TODO add sensitivity control
      deltaX *= 4;
      deltaY *= 4

      isMovingRef.current = false;
      lastPosition.current = position;

      if (deltaX === 0 && deltaY === 0) {
        return;
      }
      console.log("Moving by:", deltaX, deltaY);
      invoke("move_relative", { x: deltaX, y: deltaY }).catch((err) =>
        console.error("Invoke error:", err)
      );
      animationFrameRef.current = requestAnimationFrame(moveCursor);
    };
    animationFrameRef.current = requestAnimationFrame(moveCursor);

    return () => {
      if (animationFrameRef.current) {
        cancelAnimationFrame(animationFrameRef.current);
      }
    };
  }, [position]); // ✅ Runs only when position updates

  const handleConnection = () => {
    setIsConnected((prev) => !prev);
  };

  return (
    <div className="w-full h-screen flex items-center justify-center p-4">
      <h1 className="text-6xl">Hand.</h1>

      <div className="absolute bottom-8 left-8 bg-white p-4 rounded shadow">
        <p className="text-2xl">
          {isConnected
            ? `Current Gesture: ${
                parsedHands[0]?.gestures[0]?.name ?? "🪤 waiting..."
              }`
            : "🐁 Please connect..."}
        </p>

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
