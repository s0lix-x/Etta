import express from "express";
import authRouter from "./routes/auth/auth.route";

const app = express();
const PORT = 3000;

app.get("/", (req, res) => {
  res.send("Hello Express + TypeScript!");
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});

app.use(express.json());

app.use('/api/v1/auth', authRouter);
