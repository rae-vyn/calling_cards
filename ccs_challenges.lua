SMODS.Back {
    key = "fragile_deck",
    loc_txt = {
        name = "Fragile Deck",
        text = {"A deck", "of {C:attention}glass{} cards", "{C:mult}X3{} blind"}
    },
    config = {ante_scaling = 3},
    apply = function(back)
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, card in ipairs(G.playing_cards) do
                    card:set_ability(G.P_CENTERS.m_glass)
                end
                return true
            end
        }))
    end
}

SMODS.Challenge {
    key = "thefragile",
    loc_txt = {name = "The Fragile"},
    rules = {custom = {{id = 'glass'}}},
    jokers = {
        {id = 'j_ccs_thebone', eternal = true},
        {id = 'j_ccs_thefeather', eternal = true}
    },
    deck = {enhancement = 'm_glass'}
}

SMODS.Challenge {
    key = 'themystic',
    loc_txt = {name = "The Mystic"},
    rules = {custom = {{id = "no_shop_jokers"}}},
    jokers = {{id = 'j_cartomancer', eternal = true, edition = 'negative'}},
    consumeables = {{id = 'c_judgement'}, {id = 'c_judgement'}, {id = 'c_soul'}},
    vouchers = {
        {id = "v_tarot_merchant"}, {id = "v_tarot_tycoon"},
        {id = "v_crystal_ball"}, {id = "v_omen_globe"}
    },
    restrictions = {
        banned_cards = {
            {id = "p_buffoon_normal_1"}, {id = "p_buffoon_normal_1"},
            {id = "p_buffoon_normal_2"}, {id = "p_buffoon_jumbo_1"},
            {id = "p_buffoon_mega_1"}
        },
        banned_tags = {
            {id = 'tag_uncommon'}, {id = 'tag_rare'}, {id = 'tag_negative'},
            {id = 'tag_foil'}, {id = 'tag_holo'}, {id = 'tag_polychrome'},
            {id = 'tag_buffoon'}, {id = 'tag_top_up'}
        }
    },
    deck = {seal = "Purple"}
}
