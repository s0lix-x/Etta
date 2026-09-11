import express from "express";
import authRouter from "./routes/auth/auth.route";
import postsRouter from "./routes/posts/posts.route";
import usersRouter from "./routes/users/users.route";
import categoriesRouter from "./routes/categories/categories.route"

const app = express();
const PORT = 5000;

app.get("/", (req, res) => {
  res.send("Hello Express + TypeScript!");
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});

app.use(express.json());

app.use('/api/v1/auth', authRouter);
app.use("/api/v1/posts", postsRouter);
app.use("/api/v1/users", usersRouter);
app.use("/api/v1/categories", categoriesRouter);
