const pool = require('../db/connect');

const motosFields = 'placa, manutencao, alugada, aluguel_data_retirada, aluguel_data_entrega, aluguel_local_retirada, aluguel_local_entrega, reservada, reserva_data_retirada, reserva_data_entrega, reserva_local_retirada, reserva_local_entrega'

exports.getAllWithLocal = async (req,res) => {
    query = `select ${motosFields},endereco from motos left join locais using (local_id) order by endereco`
    const result = await pool.query(query)
    let motos = await expandLocal(result.rows)
    res.send(motos)
}

exports.getAllWhen = async (req,res) => {
    const { date } = req.params
    query = `select ${motosFields},endereco from motos left join locais using (local_id) order by endereco`
    const result = await pool.query(query)
    let motos = await expandLocal(result.rows)
    res.send(motosWhen(motos,date))
}

const expandLocal = async (motos) => {
    let locais = await pool.query(`select local_id,endereco from locais`)
    locais = locais.rows.reduce((dict,local) => {
        dict[local.local_id] = local.endereco
        return dict
    }, {})

    return motos.map(moto => {
        moto.aluguel_local_retirada = moto.aluguel_local_retirada ? locais[moto.aluguel_local_retirada] : null
        moto.aluguel_local_entrega = moto.aluguel_local_entrega ? locais[moto.aluguel_local_entrega] : null
        moto.reserva_local_retirada = moto.reserva_local_retirada ? locais[moto.reserva_local_retirada] : null
        moto.reserva_local_entrega = moto.reserva_local_entrega ? locais[moto.reserva_local_entrega] : null
        return moto
    })
}

exports.expandLocal = expandLocal

const motosWhen = (motos, inputDate) => {
    return motos.map(moto => {
        const [aluguel_data_entrega, reserva_data_retirada, reserva_data_entrega, date] = [moto.aluguel_data_entrega, moto.reserva_data_retirada, moto.reserva_data_entrega, inputDate].map(d => new Date(d))

        if (moto.alugada && aluguel_data_entrega < date) {
            moto.endereco = moto.aluguel_local_entrega
            moto.alugada = false
            moto.aluguel_data_retirada = null
            moto.aluguel_data_entrega = null
            moto.aluguel_local_retirada = null
            moto.aluguel_local_entrega = null            
        }

        if (moto.reservada && reserva_data_retirada < date) {
            if (reserva_data_entrega > date) {
                moto.alugada = true
                moto.aluguel_data_retirada = reserva_data_retirada
                moto.aluguel_data_entrega = reserva_data_entrega
                moto.aluguel_local_retirada = moto.reserva_local_retirada
                moto.aluguel_local_entrega = moto.reserva_local_entrega
                moto.endereco = null
            } else {
                moto.endereco = moto.reserva_local_entrega
            }
            moto.reservada = false
            moto.reserva_data_retirada = null
            moto.reserva_data_entrega = null
            moto.reserva_local_retirada = null
            moto.reserva_local_entrega = null
        }
        return moto
    })
}

exports.motosWhen = motosWhen