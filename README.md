# AntiSpoof

This mod rejects the registration of usernames too similar to the existing ones. For example, if `1F616EMO_c` is registered, the following usernames are banned:

1. `1F616EM0_c` ("0" is a number zero)
2. `IF616EMO_c` ("I" is an capital letter)
3. `lF616EMO_c` ("l" is a small letter)
4. `1F616EMO-c` (underscore replaced with a dash)

Do not forget to run the database update script (chat command `/as_db_init`) after the installation and every time after the `_as.flattern_map` table is updated (or if you are unsure, every time you update this mod).
