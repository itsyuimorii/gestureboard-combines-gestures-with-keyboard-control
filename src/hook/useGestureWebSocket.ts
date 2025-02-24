import { useState } from "react";
import useWebSocket from "react-use-websocket";
import zod from 'zod';

const handsSchema = zod.array(zod.object({
    gestures: zod.object({
        name: zod.string(),
        confidence: zod.number(),
    }),
    hand: zod.object({
        handedness: zod.string(),
        keypoints: zod.array(zod.object({
            x: zod.number(),
            y: zod.number(),
            z: zod.number(),
        })),
        keypoints3D  : zod.array(zod.object({
            x: zod.number(),
            y: zod.number(),
            z: zod.number(),
        })),
        score: zod.number(),
    })
}));


const SOCKET_URL = "ws://localhost:8081";

export const useGestureWebsocket = () => {
    const [isConnected, setIsConnected] = useState(false);

    const { lastMessage } = useWebSocket(SOCKET_URL, {
        shouldReconnect: () => true,
        onOpen: () => console.log("Connected"),
        onClose: () => console.log("Disconnected"),
    }, isConnected);

    const parsedHands = lastMessage ? handsSchema.safeParse(lastMessage).data : [];

    return { parsedHands, isConnected, setIsConnected };
}
