import { Router } from "express";
import categoriesController from "../../controller/categories/categories.controller";

const router = Router()

router.get('/', categoriesController.getCategories)

export default router