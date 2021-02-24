CREATE TABLE "public"."user"("ethAddress" text NOT NULL, "userName" text, PRIMARY KEY ("ethAddress") , UNIQUE ("ethAddress"), UNIQUE ("userName"));
