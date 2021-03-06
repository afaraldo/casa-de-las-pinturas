class Caja < ActiveRecord::Base

  acts_as_paranoid

  validates :nombre, presence: true, length: {maximum: 50, minimum: 2}

  default_scope { order('lower(nombre)') } # Ordenar por nombre por defecto
  scope :by_codigo, lambda { |value| where('lower(codigo) = ?', value.downcase) } # buscar por codigo

  # retorna una caja a partir de un forma
  # busca por el nombre de la caja
  def self.get_caja_por_forma(forma)
    find_by('lower(nombre) = ?', forma)
  end

  # retorna el saldo de las monedas dadas de la caja
  def saldos_por_moneda(monedas)
    saldos = {}
    monedas.each do |m|
      s = CajaPeriodoBalance.saldo_por_moneda(id, m).first
      saldos[m] = s.nil? ? 0 : s.balance
    end
    saldos
  end

  # retorna el saldo de las monedas dadas de la caja
  def saldos_total_en_moneda_por_defecto
    saldo = 0
    monedas = Moneda.all
    saldo_monedas = saldos_por_moneda(Moneda.all.map(&:id))
    saldo_monedas.each_with_index{|monto, i| saldo += monto[1] * monedas[i].cotizacion}
    saldo
  end

end
