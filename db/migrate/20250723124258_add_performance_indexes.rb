class AddPerformanceIndexes < ActiveRecord::Migration[7.2]
  def change
    # PostgreSQLのtrigram拡張を有効化（GINインデックス用）
    enable_extension 'pg_trgm' if extension_enabled?('pg_trgm') == false

    # 1. 季節フィルタ最適化
    add_index :seasons, [ :start_month, :end_month ], name: 'index_seasons_on_start_month_and_end_month'

    # 2. 価格降下検索最適化
    add_index :prices, [ :vegetable_id, :date ],
              order: { date: :desc },
              name: 'index_prices_on_vegetable_id_and_date_desc'

    # 3. 野菜名LIKE検索最適化（PostgreSQL GINインデックス）
    add_index :vegetables, :name,
              using: :gin,
              opclass: { name: :gin_trgm_ops },
              name: 'index_vegetables_on_name_gin_trgm'

    # 4. 期限管理最適化
    add_index :fridge_items, :expire_date, name: 'index_fridge_items_on_expire_date'
  end
end
