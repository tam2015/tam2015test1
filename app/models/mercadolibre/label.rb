module Mercadolibre
  class Label < ActiveRecord::Base

    # Correios' webservice gem allowed services
    #
    # :pac                         # 41106 - PAC sem contrato
    # :pac_com_contrato            # 41068 - PAC com contrato
    # :pac_gf                      # 41300 - PAC para grandes formatos
    # :sedex                       # 40010 - SEDEX sem contrato
    # :sedex_a_cobrar              # 40045 - SEDEX a Cobrar, sem contrato
    # :sedex_a_cobrar_com_contrato # 40126 - SEDEX a Cobrar, com contrato
    # :sedex_10                    # 40215 - SEDEX 10, sem contrato
    # :sedex_hoje                  # 40290 - SEDEX Hoje, sem contrato
    # :sedex_com_contrato_1        # 40096 - SEDEX com contrato
    # :sedex_com_contrato_2        # 40436 - SEDEX com contrato
    # :sedex_com_contrato_3        # 40444 - SEDEX com contrato
    # :sedex_com_contrato_4        # 40568 - SEDEX com contrato
    # :sedex_com_contrato_5        # 40606 - SEDEX com contrato
    # :e_sedex                     # 81019 - e-SEDEX, com contrato
    # :e_sedex_prioritario         # 81027 - e-SEDEX Prioritário, com contrato
    # :e_sedex_express             # 81035 - e-SEDEX Express, com contrato
    # :e_sedex_grupo_1             # 81868 - (Grupo 1) e-SEDEX, com contrato
    # :e_sedex_grupo_2             # 81833 - (Grupo 2) e-SEDEX, com contrato
    # :e_sedex_grupo_3             # 81850 - (Grupo 3) e-SEDEX, com contrato

    # Application's allowed services
    belongs_to :shipping
    SHIPPING_SERVICES = %w(pac sedex)

    default_scope  { order(:shipping_id => :desc) }

  end
end
