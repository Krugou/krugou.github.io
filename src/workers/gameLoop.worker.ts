// minimal game loop worker
// messages received: { action: 'start' | 'stop' }
// messages posted: { type: 'gameTick' } or { type: 'eventTick' }

let gameTimer: number | undefined;
let eventTimer: number | undefined;

self.onmessage = (e) => {
  const data = e.data;
  if (data.action === 'start') {
    if (gameTimer === undefined) {
      gameTimer = setInterval(() => {
        self.postMessage({ type: 'gameTick' });
      }, 1000);
    }
    if (eventTimer === undefined) {
      eventTimer = setInterval(() => {
        self.postMessage({ type: 'eventTick' });
      }, 5000);
    }
  } else if (data.action === 'stop') {
    if (gameTimer !== undefined) {
      clearInterval(gameTimer);
      gameTimer = undefined;
    }
    if (eventTimer !== undefined) {
      clearInterval(eventTimer);
      eventTimer = undefined;
    }
  }
};
