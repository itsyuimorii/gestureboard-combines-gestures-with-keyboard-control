import { useState } from "react";
import useWebSocket from "react-use-websocket";
import zod from "zod";

const handsSchema = zod.array(
  zod.object({
    gestures: zod.array(
      zod.object({
        name: zod.string(),
        score: zod.number(),
      })
    ),
    hand: zod.object({
      handedness: zod.string(),
      keypoints: zod.array(
        zod.object({
          x: zod.number(),
          y: zod.number(),
          name: zod.string(),
        })
      ),
      keypoints3D: zod.array(
        zod.object({
          x: zod.number(),
          y: zod.number(),
          z: zod.number(),
          name: zod.string(),
        })
      ),
      score: zod.number(),
    }),
  })
);

const SOCKET_URL = "ws://localhost:8081";

export const useGestureWebsocket = () => {
  const [isConnected, setIsConnected] = useState(false);

  const { lastMessage } = useWebSocket(
    SOCKET_URL,
    {
      shouldReconnect: () => true,
      onOpen: () => console.log("Connected"),
      onClose: () => console.log("Disconnected"),
    },
    isConnected
  );
  //const parsedHands = handsSchema.safeParse(lastMessage?.data).data || [];
  type ParsedHandsType = zod.infer<typeof handsSchema>;
  
 

  let parsedHands: ParsedHandsType = [];

  if(!lastMessage?.data){
    return { parsedHands, isConnected, setIsConnected };
  }
  const parsedResult = handsSchema.safeParse(JSON.parse(lastMessage?.data));
  console.log(  JSON.parse(lastMessage?.data))

  if (parsedResult.success) {
    parsedHands = parsedResult.data;
  } else {
    console.error(parsedResult.error);
  }

  return { parsedHands, isConnected, setIsConnected };
};
