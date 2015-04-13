<?php
namespace NovoCantico\Util;

use \RecursiveIteratorIterator;

class Util
{
    /**
     * Monta o arranjo com os dados do hino no formato adequado para a edição
     * @param  string $caminho
     * @return array
     */
    public static function montarHinoParaEdicao($caminho)
    {
        $hino = Util::xmlToArray(simplexml_load_string(file_get_contents($caminho), 'SimpleXMLElement'));
        
        $hino['hino']['texto'] = Util::formatarTexto($hino['hino']['texto']);
        
        if (isset($hino['hino']['referenciaBiblica'])) {
            if(isset($hino['hino']['referenciaBiblica'][0])) {
                foreach($hino['hino']['referenciaBiblica'] as $indice => $referencia) {
                    $hino['hino']['referenciaBiblica'][$indice]['@id'] = explode('_', $referencia['@id']);
                }
            } else {
                $hino['hino']['referenciaBiblica'][0]['@id'] = explode('_', $hino['hino']['referenciaBiblica']['@id']);
                $hino['hino']['referenciaBiblica'][0]['$'] = $hino['hino']['referenciaBiblica']['$'];
                unset($hino['hino']['referenciaBiblica']['@id'], $hino['hino']['referenciaBiblica']['$']);
            }    
        }
        
        if(isset($hino['hino']['origemLetra'])) {
            if(!isset($hino['hino']['origemLetra'][0])) {
                $hino['hino']['origemLetra'][0]['@id'] = $hino['hino']['origemLetra']['@id'];
                $hino['hino']['origemLetra'][0]['$'] = $hino['hino']['origemLetra']['$'];
                if(isset($hino['hino']['origemLetra']['@ano'])) {
                    $hino['hino']['origemLetra'][0]['$'] .= ', ' . $hino['hino']['origemLetra']['@ano'];
                    unset($hino['hino']['origemLetra']['@ano']);
                }
                unset($hino['hino']['origemLetra']['@id'], $hino['hino']['origemLetra']['@referencia'], $hino['hino']['origemLetra']['@ano'], $hino['hino']['origemLetra']['$']);
            } else {
                foreach($hino['hino']['origemLetra'] as $indice => $referencia) {
                    if(isset($referencia['@ano'])) {
                        $referencia['$'] .= ', ' . $referencia['@ano'];
                        unset($referencia['@ano']);
                    }
                    unset($referencia['@referencia']);
                    $hino['hino']['origemLetra'][$indice] = $referencia;
                }
            }
        }

        if(isset($hino['hino']['origemMusica'])) {
            if(!isset($hino['hino']['origemMusica'][0])) {
                $hino['hino']['origemMusica'][0]['@id'] = $hino['hino']['origemMusica']['@id'];
                $hino['hino']['origemMusica'][0]['$'] = $hino['hino']['origemMusica']['$'];
                if(isset($hino['hino']['origemMusica']['@ano'])) {
                    $hino['hino']['origemMusica'][0]['$'] .= ', ' . $hino['hino']['origemMusica']['@ano'];
                    unset($hino['hino']['origemMusica']['@ano']);
                }
                unset($hino['hino']['origemMusica']['@id'], $hino['hino']['origemMusica']['@referencia'], $hino['hino']['origemMusica']['@ano'], $hino['hino']['origemMusica']['$']);
            } else {
                foreach($hino['hino']['origemMusica'] as $indice => $referencia) {
                    if(isset($referencia['@ano'])) {
                        $referencia['$'] .= ', ' . $referencia['@ano'];
                        unset($referencia['@ano']);
                    }
                    unset($referencia['@referencia']);
                    $hino['hino']['origemMusica'][$indice] = $referencia;
                }
            }
        }

        return $hino;
    }

    /**
     * Obtém descritor de items dos tipos: assunto, seção e livros bíblicos
     * @param  string $tipo
     * @param  string $numero
     * @return string
     */
    public static function obterRotulo($tipo, $numero)
    {
        $rotulos = json_decode(file_get_contents('app/data/' . $tipo . '.json'), true);

        $iterador = new \RecursiveIteratorIterator(new \RecursiveArrayIterator($rotulos));
        foreach($iterador as $sub) {
            $subnivel = $iterador->getSubIterator();
            if($subnivel['numero'] == $numero) {
                return $subnivel['nome'];
            }
        }
    }

    /**
     * Adiciona um nome à lista de sugestões caso ainda não exista lá
     * @param  string $tipo
     * @param  string $nome
     */
    public static function incluirSugestao($tipo, $nome)
    {
        $listaJSON = json_decode(file_get_contents('app/data/origem' . $tipo . '.json'), true);
        $item = array("nome" => $nome);

        if (!in_array($item, $listaJSON['origem' . $tipo])) {
            array_push($listaJSON['origem' . $tipo], $item);
        }

        file_put_contents('app/data/origem' . $tipo . '.json', json_encode($listaJSON));
    }

    /**
     * Cria string com nomes para sugestão de preenchimento do formulário no formato
     * utilizado pelo Bootstrap
     * @param  string $tipo
     * @return string
     */
    public static function recuperarListaSugestoes($tipo)
    {
        $listaJSON = json_decode(file_get_contents('app/data/origem' . $tipo . '.json'), true);

        $lista = array_map(function($item) {
            return $item['nome'];
        }, $listaJSON['origem' . $tipo]);

        return '["' . implode('","', $lista) . '"]';
    }


    /**
     * Cria uma versão formatada do texto de um hino para apresentação no formulário
     * @param  array  $texto
     * @return string
     */
    public static function formatarTexto($texto)
    {
        $textoFormatado = '';
        while(list($var, $val) = each($texto['estrofe'])) {
            var_dump($val);
            
            if(!isset($val['verso'])) {
                $val['verso'] = $val;
            }

            for($i = 0; $i < count($val['verso']); $i++) {
                $textoFormatado .= $val['verso'][$i] . "\n";
            }

            if(isset($val['coro'])) {
                while(list($varCoro, $valCoro) = each($val['coro'])) {
                    for($i = 0; $i < count($valCoro); $i++) {
                        $textoFormatado .= "\t" . $valCoro[$i] . "\n";
                    }
                }
            }
            $textoFormatado .= "\n";
        }

        return trim($textoFormatado, "\n");
    }

    public static function xmlToArray($xml, $options = array())
    {
        $defaults = array(
            'namespaceSeparator' => ':',//you may want this to be something other than a colon
            'attributePrefix' => '@',   //to distinguish between attributes and nodes with the same name
            'alwaysArray' => array(),   //array of xml tag names which should always become arrays
            'autoArray' => true,        //only create arrays for tags which appear more than once
            'textContent' => '$',       //key used for the text content of elements
            'autoText' => true,         //skip textContent key if node has no attributes or child nodes
            'keySearch' => false,       //optional search and replace on tag and attribute names
            'keyReplace' => false       //replace values for above search values (as passed to str_replace())
        );
        $options = array_merge($defaults, $options);
        $namespaces = $xml->getDocNamespaces();
        $namespaces[''] = null; //add base (empty) namespace
     
        //get attributes from all namespaces
        $attributesArray = array();
        foreach($namespaces as $prefix => $namespace) {
            foreach($xml->attributes($namespace) as $attributeName => $attribute) {
                //replace characters in attribute name
                if($options['keySearch']) $attributeName = str_replace($options['keySearch'], $options['keyReplace'], $attributeName);
                $attributeKey = $options['attributePrefix'] . ($prefix ? $prefix . $options['namespaceSeparator'] : '') . $attributeName;
                $attributesArray[$attributeKey] = (string)$attribute;
            }
        }
     
        //get child nodes from all namespaces
        $tagsArray = array();
        foreach($namespaces as $prefix => $namespace) {
            foreach($xml->children($namespace) as $childXml) {
                //recurse into child nodes
                $childArray = Util::xmlToArray($childXml, $options);
                list($childTagName, $childProperties) = each($childArray);
     
                //replace characters in tag name
                if($options['keySearch']) $childTagName =
                        str_replace($options['keySearch'], $options['keyReplace'], $childTagName);
                //add namespace prefix, if any
                if($prefix) $childTagName = $prefix . $options['namespaceSeparator'] . $childTagName;
     
                if(!isset($tagsArray[$childTagName])) {
                    //only entry with this key
                    //test if tags of this type should always be arrays, no matter the element count
                    $tagsArray[$childTagName] = in_array($childTagName, $options['alwaysArray']) || !$options['autoArray'] ? array($childProperties) : $childProperties;
                } elseif (is_array($tagsArray[$childTagName]) && array_keys($tagsArray[$childTagName]) === range(0, count($tagsArray[$childTagName]) - 1)) {
                    //key already exists and is integer indexed array
                    $tagsArray[$childTagName][] = $childProperties;
                } else {
                    //key exists so convert to integer indexed array with previous value in position 0
                    $tagsArray[$childTagName] = array($tagsArray[$childTagName], $childProperties);
                }
            }
        }
     
        //get text content of node
        $textContentArray = array();
        $plainText = trim((string)$xml);
        if($plainText !== '') $textContentArray[$options['textContent']] = $plainText;
     
        //stick it all together
        $propertiesArray = !$options['autoText'] || $attributesArray || $tagsArray || ($plainText === '')
                ? array_merge($attributesArray, $tagsArray, $textContentArray) : $plainText;
     
        //return node as array
        return array(
            $xml->getName() => $propertiesArray
        );
    }
}