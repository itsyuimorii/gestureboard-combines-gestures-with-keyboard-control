import { useEffect } from "react";
import { useGestureWebsocket } from "../hook/useGestureWebSocket";
import { invoke } from "@tauri-apps/api/core";

const HandPage = () => {
  const { parsedHands, isConnected, setIsConnected } = useGestureWebsocket();


  useEffect(() => {
    if (!parsedHands.length) return;
    parsedHands.forEach((hand) => {
      hand.gestures.forEach((gesture) => {
        invoke("greet", { name: gesture.name }).then((message) =>
          console.log(message)
        );
        invoke("move_mouse");
      });
    });
  }, [parsedHands]);

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
