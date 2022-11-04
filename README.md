# Novo Cântico

[Novo Cântico](http://novocantico.com.br/) é um projeto para disponibilização estruturada do hinário da [Igreja Presbiteriana do Brasil](https://ipb.org.br/) na internet. Cada hino é codificado em um arquivo XML com sua letra e seus metadados.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<hino
    num="1"
    tit="Doxologia"
    sec="01_Louvor_e_Adoração"
    ass="01_01_Intróitos"
    met="Irregular">
    <tit_ori>Justus Dominus</tit_ori>
    <ori_let id="CunhaA" />
    <ori_mus id="MasonL" />
    <ori_mus id="ManuelRE" ano="1975" />
    <ref_bib liv="Sl" cap="119" ver="137" />
    <ref_bib liv="Sl" cap="145" ver="17,18" />
    <tex>
        <est>
            <ver>Justo é o Senhor em seus santos caminhos,</ver>
            <ver>Benigno em todas as suas obras.</ver>
            <ver>Perto está o Senhor, perto está dos que o invocam,</ver>
            <ver>De todos os que o invocam</ver>
            <ver>Em verdade. Aleluia! Aleluia!</ver>
        </est>
    </tex>
</hino>
```

Os arquivos são processados para construir os índices e gerar páginas HTML para navegação no endereço [www.novocantico.com.br](http://novocantico.com.br/).
