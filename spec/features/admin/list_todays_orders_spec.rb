require 'rails_helper'

RSpec.feature 'その日に予約があったお弁当の種類と数の一覧', type: :feature do
  given!(:order) { create(:order) }
  given!(:lunchbox) { create(:lunchbox) }

  scenario '固定の URL でその日の予約の数を見ることが出来る' do
    Timecop.freeze(order.date) do
      create(:order_item, lunchbox_id: lunchbox.id, order: order)
      create(:order_item, lunchbox_id: lunchbox.id, order: order)

      visit todays_order_admin_orders_path

      expect(page).to have_text("今日（#{I18n.l(order.date)}）の予約一覧")
      expect(page).to have_text(lunchbox.name)
      expect(page).to have_text(2) # NOTE: 個数が表示される
      expect(page).to have_text(2 * lunchbox.price)
      expect(page).not_to have_text('予約締め切り時間')
    end
  end
end
