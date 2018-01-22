import React from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import ImmutablePureComponent from 'react-immutable-pure-component';
import LoadingIndicator from '../../../components/loading_indicator';
import { fetchScheduledStatuses, expandScheduledStatuses } from '../../../actions/schedules';
import StatusList from '../../../components/status_list';
import ComposeFormContainer from '../../compose/containers/compose_form_container';
import NotificationsContainer from '../../ui/containers/notifications_container';
import LoadingBarContainer from '../../ui/containers/loading_bar_container';
import ModalContainer from '../../ui/containers/modal_container';

const mapStateToProps = state => ({
  statusIds: state.getIn(['status_lists', 'schedules', 'items']),
  loaded: state.getIn(['status_lists', 'schedules', 'loaded']),
  hasMore: !!state.getIn(['status_lists', 'schedules', 'next']),
});

@connect(mapStateToProps)
export default class ScheduledStatuses extends ImmutablePureComponent {

  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    statusIds: ImmutablePropTypes.list.isRequired,
    hasMore: PropTypes.bool,
    loaded: PropTypes.bool,
  };

  componentDidMount () {
    this.props.dispatch(fetchScheduledStatuses());
  }

  handleScrollToBottom = () => {
    this.props.dispatch(expandScheduledStatuses());
  }

  render () {
    const { loaded, statusIds, hasMore } = this.props;

    const statusList = loaded ? (
      <StatusList
        scrollKey='scheduledStatuses'
        trackScroll={false}
        statusIds={statusIds}
        hasMore={hasMore}
        me={null}
        schedule
        onScrollToBottom={this.handleScrollToBottom}
      />
    ) : (
      <LoadingIndicator />
    );

    return (
      <div className='scheduled_statuses'>
        <ComposeFormContainer scheduling />
        {statusList}
        <NotificationsContainer />
        <ModalContainer />
        <LoadingBarContainer className='loading-bar' />
      </div>
    );
  }

}
