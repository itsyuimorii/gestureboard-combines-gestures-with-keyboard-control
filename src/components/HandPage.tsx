import { useEffect, useRef } from "react";
import { useGestureWebsocket } from "../hook/useGestureWebSocket";
import { invoke } from "@tauri-apps/api/core";
import { HandType } from "../hook/useGestureWebSocket";

enum StateType {
  IDLE = "IDLE",
  MOVING = "MOVING",
  SCROLLING = "SCROLLING",
  CLICKING = "CLICKING",
  PRESS = "PRESS",
  RELEASE = "RELEASE",
}

type State = {
  firstPosition: { x: number; y: number } | null;
  secondPosition: { x: number; y: number } | null;
  stateType: StateType;
  lastUpdated: number;
};
const getHandPosition = (hand: HandType) => {
  const detectedWrist = hand.keypoints.find(
    (keypoint) => keypoint.name === "wrist"
  );
  if (!detectedWrist) return null;
  return {
    x: Math.round(detectedWrist.x),
    y: Math.round(detectedWrist.y),
  };
};

const HandPage = () => {
  const { parsedHands, isConnected, setIsConnected } = useGestureWebsocket();

  const state = useRef<State>({
    firstPosition: null,
    secondPosition: null,
    stateType: StateType.IDLE,
    lastUpdated: Date.now(),
  });

  useEffect(() => {
    if (!parsedHands.length) return;

    if (state.current.lastUpdated + 2000 < Date.now()) {
      state.current = {
        firstPosition: null,
        secondPosition: null,
        stateType: StateType.IDLE,
        lastUpdated: Date.now(),
      };
    }

    let newState = StateType.IDLE;
    let newPosition = null;

    parsedHands.forEach((parsedHand) => {
      // TODO should filter to only hand gestures we are targeting
      // before reducing to the highest score
      const gesture = parsedHand.gestures.reduce((prev, current) =>
        prev.score > current.score ? prev : current
      );
      if (gesture.name === "FOUR_FINGER_UP") {
        newPosition = getHandPosition(parsedHand.hand);
        newState = StateType.SCROLLING;
      } else if (gesture.name === "OK_SIGN") {
        newState = StateType.CLICKING;
      } else if (gesture.name === "U_SIGN") {
        newPosition = getHandPosition(parsedHand.hand);
        newState = StateType.MOVING;
      } else if (gesture.name === "DRAG_SIGN") {
        newPosition = getHandPosition(parsedHand.hand);
        newState = StateType.PRESS;
      }
    });

    if (newState !== state.current.stateType) {
      state.current.firstPosition = null;
      state.current.secondPosition = null;
      state.current.stateType = newState;
    }

    if (state.current.firstPosition === null) {
      state.current.firstPosition = newPosition;
    } else if (
      state.current.secondPosition === null &&
      newPosition &&
      isDifferent(state.current.firstPosition, newPosition)
    ) {
      state.current.secondPosition = newPosition;
    }

    state.current.lastUpdated = Date.now();

    processState();
  }, [parsedHands]);

  const isDifferent = (
    first: { x: number; y: number },
    second: { x: number; y: number }
  ) => {
    return Math.abs(first.x - second.x) > 1 || Math.abs(first.y - second.y) > 1;
  };

  const processState = () => {
    if (state.current.stateType === StateType.IDLE) {
      return;
    }

    if (state.current.stateType === StateType.MOVING) {
      if (
        state.current.firstPosition === null ||
        state.current.secondPosition === null
      ) {
        return;
      }
      const deltaX =
        state.current.secondPosition.x - state.current.firstPosition.x;
      const deltaY =
        state.current.secondPosition.y - state.current.firstPosition.y;

      console.log("Moving by:", deltaX, deltaY);
      invoke("move_relative", { x: deltaX, y: deltaY }).catch((err) =>
        console.error("Invoke error:", err)
      );
    }

    if (state.current.stateType === StateType.SCROLLING) {
      if (
        state.current.firstPosition === null ||
        state.current.secondPosition === null
      ) {
        return;
      }
      const deltaY =
        state.current.secondPosition.y - state.current.firstPosition.y;

      // TODO pass amount to command
      if (deltaY < 0) {
        console.log("Scrolling up");
        invoke("scroll_up").catch((err) => console.error("Invoke error:", err));
      } else {
        console.log("Scrolling down");
        invoke("scroll_down").catch((err) =>
          console.error("Invoke error:", err)
        );
      }
    }

    if (state.current.stateType === StateType.CLICKING) {
      console.log("Clicking");
      invoke("mouse_left_click").catch((err) =>
        console.error("Invoke error:", err)
      );
    }

    state.current = {
      firstPosition: null,
      secondPosition: null,
      stateType: StateType.IDLE,
      lastUpdated: Date.now(),
    };
  };

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
