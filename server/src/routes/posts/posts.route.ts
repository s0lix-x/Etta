import { Router } from "express";
import PostsController from "../../controller/posts/post.controller";
import { uploadSingleImage } from "../../middleware/upload.middleware";
import { authenticate } from "../../middleware/auth.middleware";


const router = Router();


router.post('/', authenticate, uploadSingleImage, PostsController.createPost);
router.get("/", PostsController.getPosts);
router.get("/:id", PostsController.getPostById);
router.patch("/:id", authenticate, uploadSingleImage, PostsController.updatePost);
router.delete("/:id", authenticate, PostsController.deletePost);

export default router;
