import {
  mysqlTable,
  mysqlEnum,
  int,
  varchar,
  text,
  timestamp,
} from "drizzle-orm/mysql-core";

export const USER_ROLES = ["user", "admin"] as const;

export const POST_STATUS = ["delete", "published"] as const;

// USERS
export const usersTable = mysqlTable("users", {
  id: int("id").autoincrement().primaryKey(),
  username: varchar("username", { length: 50 }).notNull(),
  email: varchar("email", { length: 100 }).notNull().unique(),
  password: varchar("password", { length: 255 }).notNull(),
  role: mysqlEnum("role", USER_ROLES).notNull().default("user"),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow().onUpdateNow(),
});
