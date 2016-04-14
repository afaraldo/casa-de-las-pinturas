class ChangeColumnSaldoToCajaPeriodoBalances < ActiveRecord::Migration
  def change
  	rename_column :caja_periodo_balances, :saldo, :balance
  end
end
