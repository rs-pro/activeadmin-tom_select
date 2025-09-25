# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

# Use appropriate version based on Rails version
schema_version = Rails.version.start_with?('8') ? '8.0' : '7.1'
ActiveRecord::Schema[schema_version].define(version: 0) do
  create_table 'active_admin_comments', force: :cascade do |t|
    t.string 'namespace'
    t.text 'body'
    t.string 'resource_type'
    t.integer 'resource_id'
    t.string 'author_type'
    t.integer 'author_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[author_type author_id], name: 'index_active_admin_comments_on_author'
    t.index ['namespace'], name: 'index_active_admin_comments_on_namespace'
    t.index %w[resource_type resource_id], name: 'index_active_admin_comments_on_resource'
  end

  create_table 'admin_users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_admin_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_admin_users_on_reset_password_token',
                                      unique: true
  end

  create_table 'articles', force: :cascade do |t|
    t.string 'title'
    t.text 'body'
    t.integer 'category_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['category_id'], name: 'index_articles_on_category_id'
  end

  create_table 'categories', force: :cascade do |t|
    t.string 'name'
    t.text 'description'
    t.integer 'created_by_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['created_by_id'], name: 'index_categories_on_created_by_id'
  end

  create_table 'colors', force: :cascade do |t|
    t.string 'name'
    t.string 'hex'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'internal_tag_names', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'option_types', force: :cascade do |t|
    t.string 'name'
    t.integer 'position'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'option_values', force: :cascade do |t|
    t.string 'name'
    t.integer 'option_type_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['option_type_id'], name: 'index_option_values_on_option_type_id'
  end

  create_table 'posts', force: :cascade do |t|
    t.string 'title'
    t.text 'body'
    t.integer 'category_id'
    t.integer 'created_by_id'
    t.integer 'user_id'
    t.integer 'color_id'
    t.boolean 'published', default: false
    t.integer 'position'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['category_id'], name: 'index_posts_on_category_id'
    t.index ['color_id'], name: 'index_posts_on_color_id'
    t.index ['created_by_id'], name: 'index_posts_on_created_by_id'
    t.index ['user_id'], name: 'index_posts_on_user_id'
  end

  create_table 'posts_tags', id: false, force: :cascade do |t|
    t.integer 'post_id', null: false
    t.integer 'tag_id', null: false
    t.index ['post_id'], name: 'index_posts_tags_on_post_id'
    t.index ['tag_id'], name: 'index_posts_tags_on_tag_id'
  end

  create_table 'products', force: :cascade do |t|
    t.string 'name'
    t.integer 'option_type_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['option_type_id'], name: 'index_products_on_option_type_id'
  end

  create_table 'rgb_colors', force: :cascade do |t|
    t.string 'name'
    t.string 'code'
    t.text 'description'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'taggings', force: :cascade do |t|
    t.integer 'tag_id'
    t.string 'taggable_type'
    t.integer 'taggable_id'
    t.string 'tagger_type'
    t.integer 'tagger_id'
    t.string 'context', limit: 128
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['context'], name: 'index_taggings_on_context'
    t.index %w[tag_id taggable_id taggable_type context tagger_id tagger_type],
            name: 'taggings_idx', unique: true
    t.index ['tag_id'], name: 'index_taggings_on_tag_id'
    t.index %w[taggable_id taggable_type context], name: 'taggings_taggable_context_idx'
    t.index %w[taggable_id taggable_type tagger_id context], name: 'taggings_idy'
    t.index ['taggable_id'], name: 'index_taggings_on_taggable_id'
    t.index %w[taggable_type taggable_id], name: 'index_taggings_on_taggable'
    t.index ['taggable_type'], name: 'index_taggings_on_taggable_type'
    t.index %w[tagger_id tagger_type], name: 'index_taggings_on_tagger'
    t.index ['tagger_id'], name: 'index_taggings_on_tagger_id'
    t.index %w[tagger_type tagger_id], name: 'index_taggings_on_tagger_type_and_tagger_id'
  end

  create_table 'tags', force: :cascade do |t|
    t.string 'name'
    t.integer 'taggings_count', default: 0
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_tags_on_name', unique: true
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'email'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'variants', force: :cascade do |t|
    t.integer 'product_id'
    t.integer 'option_value_id'
    t.decimal 'price'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['option_value_id'], name: 'index_variants_on_option_value_id'
    t.index ['product_id'], name: 'index_variants_on_product_id'
  end
end
