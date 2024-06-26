#include "AdaptiveCardRenderConfig.h"

namespace RendererQml
{
   
    AdaptiveCardRenderConfig::AdaptiveCardRenderConfig(bool isDarkMode, std::map<std::string, bool> featureToggleMap)
        : m_isDark(isDarkMode), mFeatureToggleMap(featureToggleMap)
    {
    }

    bool AdaptiveCardRenderConfig::isDarkMode() const
    {
        return m_isDark;
    }

    bool  AdaptiveCardRenderConfig::isAdaptiveCards1_3SchemaEnabled() const
    {
        const auto feature = mFeatureToggleMap.find("FEATURE_1_3");
        return ( feature != mFeatureToggleMap.end() && feature->second);
    }

    CardConfig AdaptiveCardRenderConfig::getCardConfig() const
    {
        return m_cardConfig;
    }

    void AdaptiveCardRenderConfig::setCardConfig(CardConfig config)
    {
        m_cardConfig = config;
    }

    InputTextConfig AdaptiveCardRenderConfig::getInputTextConfig() const
    {
        return m_textInputConfig;
    }

    void AdaptiveCardRenderConfig::setInputTextConfig(InputTextConfig config)
    {
        m_textInputConfig = config;
    }

    InputNumberConfig AdaptiveCardRenderConfig::getInputNumberConfig() const
    {
        return m_numberInputConfig;
    }

    void AdaptiveCardRenderConfig::setInputNumberConfig(InputNumberConfig config)
    {
        m_numberInputConfig = config;
    }

    InputTimeConfig AdaptiveCardRenderConfig::getInputTimeConfig() const
    {
        return m_timeInputConfig;
    }

    void AdaptiveCardRenderConfig::setInputTimeConfig(InputTimeConfig config)
    {
        m_timeInputConfig = config;
    }

    InputChoiceSetDropDownConfig AdaptiveCardRenderConfig::getInputChoiceSetDropDownConfig() const
    {
        return m_choiceSetDropdownInputConfig;
    }

    void AdaptiveCardRenderConfig::setInputChoiceSetDropDownConfig(InputChoiceSetDropDownConfig config)
    {
        m_choiceSetDropdownInputConfig = config;
    }

    ToggleButtonConfig AdaptiveCardRenderConfig::getToggleButtonConfig() const
    {
        return m_toggleButtonConfig;
    }

    void AdaptiveCardRenderConfig::setToggleButtonConfig(ToggleButtonConfig config)
    {
        m_toggleButtonConfig = config;
    }

    InputDateConfig AdaptiveCardRenderConfig::getInputDateConfig() const
    {
        return m_dateInputConfig;
    }

    void AdaptiveCardRenderConfig::setInputDateConfig(InputDateConfig config)
    {
        m_dateInputConfig = config;
    }

    ActionButtonsConfig AdaptiveCardRenderConfig::getActionButtonsConfig() const
    {
        return m_actionButtonsConfig;
    }

    void AdaptiveCardRenderConfig::setActionButtonsConfig(ActionButtonsConfig config)
    {
        m_actionButtonsConfig = config;
    }
}
