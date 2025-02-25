import { useGestureWebsocket } from '../hook/useGestureWebSocket';
 

const HandPage = () => {
  const { detectedHandGesture, isConnected, setIsConnected } = useGestureWebsocket();
  console.log("🚀 ~ HandPage ~ detectedHandGesture:", detectedHandGesture)


  const handleConnection = () => {
    setIsConnected(!isConnected);
  } 

  return (
    <>
      <div className="w-full h-screen flex items-center justify-center  p-4">

        <h1 className="text-6xl">Hand.</h1>

        <div className="absolute bottom-4 left-4 bg-white p-4 rounded shadow">
          {/* <p>Current Gesture: {detectedHandGesture ? detectedHandGesture[0] : "Waiting..."}</p> */}
          <button
            className="mt-2 px-4 py-2 bg-blue-500 text-white rounded"
            onClick={handleConnection}
          >
            {isConnected ? "Disconnect" : "Connect"}
          </button>
        </div>
      </div>

    </>
  );
};

export default HandPage;