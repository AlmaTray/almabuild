#define LOADOUT_POINTS_MAX 10
#define LOADOUT_POINTS_MAX_DONATOR 20

#define LOADOUT_CATEGORY_NONE				"ERROR"
//Those three subcategories are good to apply to any category
#define LOADOUT_SUBCATEGORY_DONATOR			"Донат-раздел"
#define LOADOUT_SUBCATEGORY_MISC			"Разное"
#define LOADOUT_SUBCATEGORY_JOB 			"Профессии"

//In backpack
#define LOADOUT_CATEGORY_BACKPACK 				"В рюкзаке"
#define LOADOUT_SUBCATEGORY_BACKPACK_TOYS 		"Игрушки"
#define LOADOUT_SUBCATEGORY_BACKPACK_FRAGRANCE "Парфюмы"
#define LOADOUT_SUBCATEGORY_BACKPACK_PLUSHIES 	"Плюшевые"

//Neck
#define LOADOUT_CATEGORY_NECK 				"Шея"
#define LOADOUT_SUBCATEGORY_NECK_TIE 		"Галстуки"
#define LOADOUT_SUBCATEGORY_NECK_SCARVES 	"Шарфы"

//Mask
#define LOADOUT_CATEGORY_MASK 				"Маски"

//In hands
#define LOADOUT_CATEGORY_HANDS 				"В руках"

//Uniform
#define LOADOUT_CATEGORY_UNIFORM 			"Униформа"
#define LOADOUT_SUBCATEGORY_UNIFORM_SUITS	"Костюмы"
#define LOADOUT_SUBCATEGORY_UNIFORM_SKIRTS	"Юбки"
#define LOADOUT_SUBCATEGORY_UNIFORM_DRESSES	"Платья"
#define LOADOUT_SUBCATEGORY_UNIFORM_SWEATERS	"Свитеры"
#define LOADOUT_SUBCATEGORY_UNIFORM_PANTS	"Штаны"
#define LOADOUT_SUBCATEGORY_UNIFORM_SHORTS	"Брюки"

//Suit
#define LOADOUT_CATEGORY_SUIT 				"Костюм"
#define LOADOUT_SUBCATEGORY_SUIT_COATS 		"Куртки"
#define LOADOUT_SUBCATEGORY_SUIT_JACKETS 	"Жакеты"
#define LOADOUT_SUBCATEGORY_SUIT_HOODIES	"Худи"

//Head
#define LOADOUT_CATEGORY_HEAD 				"Голова"

//Shoes
#define LOADOUT_CATEGORY_SHOES 				"Обувь"

//Gloves
#define LOADOUT_CATEGORY_GLOVES				"Руки"

//Glasses
#define LOADOUT_CATEGORY_GLASSES			"Глаза"

//Loadout information types, allowing a user to set more customization to them
//Doesn't store any extra information a user could set
#define LOADOUT_INFO_NONE			0
//Stores a "style", which user can set from a pre-defined list on the loadout datum
#define LOADOUT_INFO_STYLE			1
//Stores a single color for use by the loadout datum
#define LOADOUT_INFO_ONE_COLOR 		2
