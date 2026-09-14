import { Request, Response } from "express";
import {
  createPostSchema,
  postIdSchema,
  updatePostParamsSchema,
  updatePostSchema,
} from "../../validations/post.validation";
import { db } from "../../config/db";
import { categoriesTable, postsTable, usersTable } from "../../config/schema";
import { and, desc, eq, like } from "drizzle-orm";
import {
  deleteFromCloudinary,
  uploadToCloudinary,
} from "../../services/cloudinary.service";

export class PostsController {
  createPost = async (req: Request, res: Response) => {
    try {
      // 1. validation
      const validatedData = createPostSchema.parse(req.body);
      const { userId, categoryId, title, content } = validatedData;
      let imageUrl: string | undefined;
      let imagePublicId: string | undefined;
      // 2. Jika ada file yang di-upload, kirim ke Cloudinary
      if (req.file) {
        const uploadResult = await uploadToCloudinary(req.file.buffer);
        imageUrl = uploadResult.secure_url;
        imagePublicId = uploadResult.public_id;
      }
      // 3. Create New Post
      const [insertedPost] = await db
        .insert(postsTable)
        .values({
          userId,
          categoryId,
          title,
          content,
          imageUrl,
          imagePublicId,
        })
        .$returningId();
      // 4. Ambil Post yg baru di buat tadi
      const newPost = await db.query.postsTable.findFirst({
        where: eq(postsTable.id, insertedPost.id),
      });
      // 5. Tampilkan dalam API
      return res.status(201).json({
        success: true,
        message: "Post created successfully",
        data: {
          post: newPost,
        },
      });
    } catch (error: any) {
      return res.status(500).json({
        success: false,
        message: error.message,
      });
    }
  };
  // Guests: Get All
  getPosts = async (req: Request, res: Response) => {
    try {
      const search = String(req.query.search ?? "").trim();
      const categoryId = Number(req.query.categoryId);
      const searchCondition = search
        ? like(postsTable.title, `%${search}%`)
        : undefined;
      const categoryCondition = categoryId > 0
        ? eq(postsTable.categoryId, categoryId)
        : undefined;

      const posts = await db
        .select({
          id: postsTable.id,
          userId: postsTable.userId,
          categoryId: postsTable.categoryId,
          title: postsTable.title,
          content: postsTable.content,
          imageUrl: postsTable.imageUrl,
          status: postsTable.status,
          createdAt: postsTable.createdAt,
          updatedAt: postsTable.updatedAt,
          username: usersTable.username,
          category: categoriesTable.name,
        })
        .from(postsTable)
        .leftJoin(usersTable, eq(postsTable.userId, usersTable.id))
        .leftJoin(
          categoriesTable,
          eq(postsTable.categoryId, categoriesTable.id),
        )
        .where(and(
          eq(postsTable.status, "published"),
          ...(searchCondition ? [searchCondition] : []),
          ...(categoryCondition ? [categoryCondition] : []),
        ))
        .orderBy(desc(postsTable.createdAt));

      return res.status(200).json({
        success: true,
        message: "Get Posts Successfully",
        data: {
          posts: posts,
        },
      });
    } catch (error: any) {
      console.error("Read post error:", error);
      return res.status(500).json({
        success: false,
        message: "Terjadi kesalahan pada server",
        error: error instanceof Error ? error.message : error,
      });
    }
  };

  // FOR GUEST GET BY ID
  getPostById = async (req: Request, res: Response) => {
    try {
      const validateParams = postIdSchema.parse(req.params);
      const { id } = validateParams;

      const [post] = await db
        .select()
        .from(postsTable)
        .where(and(eq(postsTable.id, id), eq(postsTable.status, "published")));

      if (!post) {
        return res.status(404).json({
          success: false,
          message: "No posts found",
        });
      }

      return res.status(200).json({
        success: true,
        message: "Retrieving post succesfully",
        data: {
          post: post,
        },
      });
    } catch (error: any) {
      console.error("Read post error:", error);
      return res.status(500).json({
        success: false,
        message: "Terjadi kesalahan pada server",
        error: error instanceof Error ? error.message : error,
      });
    }
  };

  // UPDATE
  updatePost = async (req: Request, res: Response) => {
    try {
      // VALIDATE PARAMS
      const validateParams = updatePostParamsSchema.parse(req.params);
      const { id } = validateParams;

      // VALIDATE BODY
      const validateData = updatePostSchema.parse(req.body);
      const { title, content } = validateData;

      // CEK POST
      const [existingPost] = await db
        .select()
        .from(postsTable)
        .where(eq(postsTable.id, id));

      if (!existingPost) {
        return res.status(404).json({
          success: false,
          message: "Corresponding post not found",
        });
      }

      // SIAPKAN DATA UPDATE
      let imageUrl = existingPost.imageUrl;
      let imagePublicId = existingPost.imagePublicId;

      // JIKA ADA IMAGE BARU
      if (req.file) {
        const uploadResult = await uploadToCloudinary(req.file.buffer);
        imageUrl = uploadResult.secure_url;
        imagePublicId = uploadResult.public_id;

        // HAPUS IMAGE LAMA
        if (existingPost.imagePublicId) {
          await deleteFromCloudinary(existingPost.imagePublicId);
        }
      }

      // UPDATE DATABASE
      await db
        .update(postsTable)
        .set({
          ...(title !== undefined && {
            title,
          }),

          ...(content !== undefined && {
            content,
          }),

          ...(req.file && {
            imageUrl,
            imagePublicId,
          }),
        })
        .where(eq(postsTable.id, id));

      // AMBIL UPDATE TERBARU
      const [updatedPost] = await db
        .select()
        .from(postsTable)
        .where(eq(postsTable.id, id));

      // RESPONSE
      return res.status(200).json({
        success: true,
        message: "Post updated successfully",
        data: {
          post: updatedPost,
        },
      });
    } catch (error: any) {
      console.error("Update post error:", error);
      return res.status(500).json({
        success: false,
        message: "Internal server error",
        error: error.message,
      });
    }
  };

  // DELETE
  deletePost = async (req: Request, res: Response) => {
    try {
      const validateParams = postIdSchema.parse(req.params);
      const { id } = validateParams;

      const existingPost = await db.query.postsTable.findFirst({
        where: eq(postsTable.id, id),
      });

      if (!existingPost) {
        return res.status(404).json({
          success: false,
          message: "Corresponding post not found",
        });
      }

      await db
        .update(postsTable)
        .set({ status: "deleted" })
        .where(eq(postsTable.id, id));

      return res.status(200).json({
        success: true,
        message: "Post deleted successfully",
      });
    } catch (error: any) {
      console.error("Delete post error:", error);
      return res.status(500).json({
        success: false,
        message: "Internal server error",
        error: error.message,
      });
    }
  };
}

export default new PostsController();
