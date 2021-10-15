const pool = require('../db/connect');
motoController = require('../controllers/motoController')
const got = require('got');

const locaisFields = 'endereco, latitude, longitude, zona'
const motosFields = 'placa, manutencao, alugada, aluguel_data_retirada, aluguel_data_entrega, aluguel_local_retirada, aluguel_local_entrega, reservada, reserva_data_retirada, reserva_data_entrega, reserva_local_retirada, reserva_local_entrega'

exports.getAll = async (req, res) => {
    const result = await pool.query('select * from locais')
    res.send(result.rows)
}

exports.getAvaiableWhen = async (req, res) => {
    let { cep, inicio, fim } = req.params
    inicio = new Date(inicio)
    fim = new Date(fim)

    const data = await got(`https://brasilapi.com.br/api/cep/v2/${cep}`)
    console.log(data.body)
    let {latitude, longitude} = JSON.parse(data.body).location.coordinates
    latitude = parseFloat(latitude)
    longitude = parseFloat(longitude)

    let query = `select ${motosFields},endereco from motos left join locais using (local_id) order by endereco`
    let result = await pool.query(query)
    let motos = await motoController.expandLocal(result.rows)

    result = await pool.query(`select ${locaisFields} from locais`)
    let locais = result.rows

    locais =
        locais.map(local => {
            local.motos = motos.filter(moto => {
                return (
                    !moto.manutencao &&
                    !estaraReservadaEm(moto, inicio, fim) &&
                    !estaraAlugadaEm(moto, inicio, fim) &&
                    local.endereco === motoEstaraEm(moto, inicio)
                )
            }).length

            return local
        })  

    const {sqrt, pow, abs} = Math

    const localMaisProximo = locais.reduce((l1, l2) => (
        l1.motos === 0 ? l2 : l2.motos === 0 ? l1 :
            (
                sqrt(
                    pow(abs(l2.latitude - latitude), 2) +
                    pow(abs(l2.longitude - longitude), 2)
                ) <
                sqrt(
                    pow(abs(l1.latitude - latitude), 2) +
                    pow(abs(l1.longitude - longitude), 2)
                )
            ) ? l2 : l1
    ))

    // res.send(locais)

    // localMaisProximo.motos = motos.filter(moto => (
    //     !moto.manutencao &&
    //     !estaraReservadaEm(moto, inicio, fim) &&
    //     !estaraAlugadaEm(moto, inicio, fim) &&
    //     localMaisProximo.endereco === motoEstaraEm(moto, inicio)
    // )).length

    res.send(localMaisProximo)
}

const estaraAlugadaEm = (moto, inicio, fim) => {
    const [
        aluguel_data_entrega,
        aluguel_data_retirada,
        reserva_data_entrega,
        reserva_data_retirada
    ] = to_date(moto)

    return (
        moto.alugada &&
        aluguel_data_retirada <= inicio && inicio <= aluguel_data_entrega ||
        aluguel_data_retirada <= fim && fim <= aluguel_data_entrega
    )
}

const estaraReservadaEm = (moto, inicio, fim) => {
    const [
        aluguel_data_entrega,
        aluguel_data_retirada,
        reserva_data_entrega,
        reserva_data_retirada
    ] = to_date(moto)

    return (
        moto.reservada &&
        reserva_data_retirada <= inicio && inicio <= reserva_data_entrega ||
        reserva_data_retirada <= fim && fim <= reserva_data_entrega
    )
}

const motoEstaraEm = (moto, data) => {
    const [
        aluguel_data_entrega,
        aluguel_data_retirada,
        reserva_data_entrega,
        reserva_data_retirada
    ] = to_date(moto)

    if (reserva_data_entrega && reserva_data_entrega <= data) {
        return moto.reserva_local_entrega
    } else if (aluguel_data_entrega && aluguel_data_entrega <= data) {
        return moto.aluguel_local_entrega
    } else {
        return moto.endereco
    }
}

const to_date = (moto) => {
    return [
        moto.aluguel_data_entrega,
        moto.aluguel_data_retirada,
        moto.reserva_data_entrega,
        moto.reserva_data_retirada
    ].map(d => d ? new Date(d) : null)
}