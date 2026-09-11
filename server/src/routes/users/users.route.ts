import { Router } from "express";
import { authenticate } from "../../middleware/auth.middleware";
import UsersController from "../../controller/users/users.controller";

const router = Router();

router.get("/:userId", authenticate, UsersController.getPostsByUserId);
router.get("/:userId/posts/:postId", authenticate, UsersController.getUserPost);

export default router;
