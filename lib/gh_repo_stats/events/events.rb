module GHRepo
  class PushEvent < Event
    tag('push')
  end

  class CommitCommentEvent < Event
    tag('commit-comment')
  end

  class CreateEvent < Event
    tag('create')
  end

  class DeleteEvent < Event
    tag('delete')
  end

  class DeploymentEvent < Event
    tag('deployment')
  end

  class DownloadEvent < Event
    tag('download')
  end

  class DeploymentStatusEvent < Event
    tag(reformat('DeploymentStatusEvent'))
  end

  class FollowEvent < Event
    tag(reformat('FollowEvent'))
  end

  class ForkEvent < Event
    tag(reformat('ForkEvent'))
  end

  class ForkApplyEvent < Event
    tag(reformat('ForkApplyEvent'))
  end

  class GistEvent < Event
    tag(reformat('GistEvent'))
  end

  class GollumEvent < Event
    tag(reformat('GollumEvent'))
  end

  class IssueCommentEvent < Event
    tag(reformat('IssueCommentEvent'))
  end

  class IssuesEvent < Event
    tag(reformat('IssuesEvent'))
  end

  class LabelEvent < Event
    tag(reformat('LabelEvent'))
  end

  class MemberEvent < Event
    tag(reformat('MemberEvent'))
  end

  class MembershipEvent < Event
    tag(reformat('MembershipEvent'))
  end

  class MilestoneEvent < Event
    tag(reformat('MilestoneEvent'))
  end

  class OrganizationEvent < Event
    tag(reformat('OrganizationEvent'))
  end

  class OrgBlockEvent < Event
    tag(reformat('OrgBlockEvent'))
  end

  class PageBuildEvent < Event
    tag(reformat('PageBuildEvent'))
  end

  class ProjectCardEvent < Event
    tag(reformat('ProjectCardEvent'))
  end

  class ProjectColumnEvent < Event
    tag(reformat('ProjectColumnEvent'))
  end

  class ProjectEvent < Event
    tag(reformat('ProjectEvent'))
  end

  class PublicEvent < Event
    tag(reformat('PublicEvent'))
  end

  class PullRequestEvent < Event
    tag(reformat('PullRequestEvent'))
  end

  class PullRequestReviewEvent < Event
    tag(reformat('PullRequestReviewEvent'))
  end

  class PullRequestReviewCommentEvent < Event
    tag(reformat('PullRequestReviewCommentEvent'))
  end

  class ReleaseEvent < Event
    tag(reformat('ReleaseEvent'))
  end

  class RepositoryEvent < Event
    tag(reformat('RepositoryEvent'))
  end

  class StatusEvent < Event
    tag(reformat('StatusEvent'))
  end

  class TeamEvent < Event
    tag(reformat('TeamEvent'))
  end

  class TeamAddEvent < Event
    tag(reformat('TeamAddEvent'))
  end

  class WatchEvent < Event
    tag(reformat('WatchEvent'))
  end
end
