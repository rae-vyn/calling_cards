-- Atlasses
SMODS.Atlas {key = "Placeholder", px = 71, py = 95, path = "Placeholder.png"}
SMODS.Atlas {key = "TheClaw", px = 71, py = 95, path = "Claw2.png"}
SMODS.Atlas {key = "TheFeather", px = 71, py = 95, path = "TheFeather2.png"}
SMODS.Atlas {key = "TheEye", px = 71, py = 95, path = "TheEye.png"}
SMODS.Atlas {key = "TheBones", px = 71, py = 95, path = "TheBones.png"}


-- The Claw
SMODS.Joker {
    key = 'theclaw',
    loc_txt = {
        name = 'The Claw',
        text = {
            "{C:white,X:mult}+5{} Mult", 
            "per card", 
            "if hand has",
            "{C:attention}4 or more{} cards"
        }
    },

    config = {extra = { mult = 5 } },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult} }
    end,
    rarity = 2,
    atlas = 'TheClaw',
    pos = {x = 0, y = 0},
    cost = 2,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.individual and not context.end_of_round then
            if #context.full_hand >= 4 then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}

-- The Feather
SMODS.Joker {
    key = "thefeather",
    loc_txt = {
        name = "The Feather",
        text = {
            "Creates an {C:attention}base{}", "copy of the last",
            "card in scored hand"
        }
    },
    config = {},
    rarity = 3,
    atlas = "TheFeather",
    pos = {x = 0, y = 0},
    cost = 4,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.before then
            local hand_size = #context.scoring_hand
            local _card = copy_card(context.scoring_hand[hand_size],
                                    nil, nil, G.playing_card, true)
            _card:set_seal()
            _card:set_ability(G.P_CENTERS.c_base)
            _card:add_to_deck()
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            G.deck:emplace(_card)
            table.insert(G.playing_cards, _card)

            return {
                message = "Copied!"
            }
        end
    end
}
-- The Eye
SMODS.Joker {
    key = "theeye",
    loc_txt = {
        name = "The Eye",
        text = {
            "Every card bought", 
            "becomes {C:dark_edition}Negative{};",
            "{C:red}$#1#{} in addition to",
            "the inflated cost."
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    config = { extra = { money = -9} },
    rarity = 3,
    atlas = "TheEye",
    pos = {x = 0, y = 0},
    cost = 4,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.buying_card and not context.blueprint then
            context.card:set_edition("e_negative")
            ease_dollars(card.ability.extra.money)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = '$'..card.ability.extra.money, colour = G.C.GOLD})
            return
        end
    end
}

-- The Bones
SMODS.Joker {
    key = "thebones",
    loc_txt = {
        name = "The Bones",
        text = {
            "Every glass card", 
            "in played hand {C:red}breaks{}," ,
            "adds {C:attention}double rank{}", 
            "to mult"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    config = { },
    rarity = 3,
    atlas = "TheBones", 
    pos = {x = 0, y = 0},
    cost = 4,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.joker_main and not context.blueprint then
            local total_mult = 0
            for _, _card in ipairs(context.full_hand) do
                local card_rank = _card:get_id()
                if _card.ability.effect == 'glass' then
                    print(card_rank)
                    _card:shatter()
                    total_mult = total_mult + 2 * card_rank
                end
            end
            return {
                mult = total_mult
            }
        end
    end
}